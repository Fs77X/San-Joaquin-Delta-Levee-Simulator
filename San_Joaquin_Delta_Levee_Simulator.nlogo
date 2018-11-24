breed [waters water]
breed [grounds ground]
breed [levees levee]
breed [plants plant]
breed [watertables watertable]
breed [pumps pump]
breed [flatbeds flatbed]
breed [persons person]
breed [clouds cloud]
breed [rains rain]
globals [material_toughness]

to animation
  clear-all
  create-grounds 1 [                                                                                    ;all the code in to setup basically setups the background and the environment
    set color 34
    set shape "ground"
    set size 25
    setxy 0 -14.1
    set heading 180 ]
  create-levees 1 [
    set shape "levee-Left"
    set size 15
    setxy -10 -16
    set heading 0
  ]
  create-levees 1 [
    set shape "levee-right"
    set size 15
    setxy 10 -16
    set heading 0
  ]
  create-waters 1 [
    set color [ 52 111 194]
    set shape "water"
    set size 18
    setxy -15 -14.1
    set heading 180
  ]
  create-waters 1 [
    set color [ 52 111 194]
    set shape "water"
    set size 18
    setxy 16 -14.1
    set heading 180
  ]
  create-watertables 1 [
    set color [ 52 111 194 80]
    set shape "watertable"
    set size 24
    setxy 0 -14.1
    set heading 180
  ]
  ask patches [set pcolor scale-color 86 (pycor) -4 20 ]show shade-of? blue red
  ask patches with [pycor < 0] [set pcolor scale-color 54 (pycor) 4 -20] show shade-of? blue red
  crt 1 [ set shape "sun" set size 13 setxy -13 13]
  create-clouds 1 [set shape "cloud2" set heading 90 set size 4 setxy -7 3]
  create-clouds 1 [set shape "cloud2" set heading 90 set size 4 setxy 10 13]
  create-clouds 1 [set shape "cloud2" set heading 90 set size 4 setxy -10 9]
end

to construction
  ask grounds [                                                                                      ; moves the ground down as the levees move up
    wait .2
    if ycor >= -16 [ fd .1]
  ]
  ask levees [                                                                                       ; moves levees up by .05 until it is <= -15 and then sets size to 15
    if ycor <= -15 [ fd .05]
    set size  15
  ]
 ask watertables [                                                                                   ; moves the translucent water table down in sync with the ground, grows so it stays even with levees
   if ycor > -16 [
   wait .2
   fd .2
   set size(size + .3)
   ]
 ]
  ask waters [
    if size <= 20 [ set size(size + .2)]                                                             ;slowly increases the waters size by adding .2 to the current size each iteration
  ]

end


to reinforcement                                                                                     ;adds rocky exterior, plants and pump
   ask levees [                                                                                      ;rocky exterior, changes shape of left side levee
     if xcor = -10 [ set shape "levee-left-rocky"]
   ]
  if count flatbeds = 0 and count plants = 0 [                                                       ;Adds the Flatbed Truck to the simulation.
  create-flatbeds 1 [
  set shape "flatbed"
  set size 3.5
  set color grey
  setxy -9 -11.55
  ]
 ]
  ask flatbeds [                                                                                    ;moves flatbed truck
    if xcor < 9 [
      set heading 90
      fd 1.5
      ]
    if xcor >= 9 [                                                                                  ;adds rocky exterior, changes shape of right side levee
      ask levees [
        if xcor = 10 [ set shape "levee-right-rocky" ]
      ]
      die
    ]
   ]
   if count persons = 0 AND count plants != 7 and count flatbeds = 0[                               ;added so plants and persons don't spawn crazily

   create-persons 1 [                                                                               ;Say hello to Jack age = ticks / x * y * z >= 100
      wait .2
      set color black
      set shape "person"
      set size 2
      setxy -7 -11.4
      set heading 90
    ]
   ]
  wait .25
  if count plants < 7 and count flatbeds = 0 [                                                      ; creates 7 plants, starting from the left side and moving towards the right
    wait .3
    create-plants 1 [
      set color green
      set shape "plant"
      set size 1.5
      setxy -7 -11.4
      set heading 90
     ]
    ask persons [                                                                                   ;commands the person to move two units until it is at an x coordinate <= 14
      if xcor <= 14 [fd 2]
    ]
    ask plants [
      if xcor <= 14 [fd 2]
     ]

 ]
  if count plants = 7 AND count pumps = 0 [                                                         ;once all 7 plants are done, creates a pump
    wait .3
    create-pumps 1
    ask pumps [
      set heading 0
      set color 7
      set shape "pump"
      set size 6
      setxy -7 -12.1
      ask persons [
        die
      ]
    ]
  ]
end

to maintenance

   ask waters [
    if xcor = 16 [                                                                                ; orients and adjusts the position of right side water
      set heading 90
      fd 1.2
      set heading 180
    ]
    if xcor = -15 [                                                                               ; "" for left
      set heading 270
      fd 1.2
      set heading 180
    ]
    if size <= 25 [                                                                               ; "raises the water level" by increasing the size of the water turtle
    wait .2
    set size(size + .5)
    ]
    if size >= 25 [                                                                               ; increases the size of the levees to compensate for increased water level
      ask levees [
        if size < 17 [
        wait .2
        set size(size + .4)
      ]
     ]
    ]
   ]
   ask watertables [                                                                              ; increases the height of the water table as the water levelp increases
     if size <= 34 [
     wait .2
     set size(size + .4)
     ]
   ]
end

to pumping
  ask watertables [                                                                               ; "pumps" out the water, decreases water level
    if size >= 28 [
      wait .2
      set size (size - .6)
    ]
  ]
end

to simulation
  clear-all
  ask patches [set pcolor scale-color 86 (pycor) -20 20 ]show shade-of? blue red                  ;creates gradient
  ask patches with [pxcor >= 12 AND pycor <= -4] [set pcolor brown]                               ; following lines set up the ground and levee
  ask patches with [pxcor = 11 AND pycor <= 1] [set pcolor green]                                 ;sets to green as a placeholder color
  ask patches with [pxcor = 10 AND pycor <= 0] [set pcolor green]
  ask patches with [pxcor = 9  AND pycor <= -1] [set pcolor green]
  ask patches with [pxcor = 8  AND pycor <= -2] [set pcolor green]
  ask patches with [pxcor = 7  AND pycor <= -3] [set pcolor  green]
  ask patches with [pxcor = 6  AND pycor <= -4] [set pcolor  green]
  if material = "Gripper System" [ ask patches with [pcolor = green] [set pcolor [51 102 0]]]     ;material specific colors for levee
  if material = "Ground" [ ask patches with [pcolor =  green] [set pcolor [102 51 0]]]
  if material = "Concrete" [ ask patches with [pcolor = green] [set pcolor [128 128 128]]]
  if material = "Rock" [ ask patches with [pcolor =  green] [set pcolor [64 64 64]]]
  if water_level - 16 > 1 [                                                                       ;if the water level is above a certain point, automatically flood the levee
     ask patches with [pcolor != [64 64 64]
       AND pcolor != [128 128 128]
       AND pcolor != [102 51 0]
       AND pcolor != [51 102 0]
       AND pcolor != green
       AND pycor < water_level - 16] [set pcolor blue]
     ask patches with [pycor <= -4
       AND pxcor >= 12][set pcolor brown]
  ]
  if water_level - 16 <= 1 [                                                                       ;if water level is above the ground, but not above the top of the levee, let water run up to the edge but not over
    ask patches with [pcolor != [64 64 64]
      AND pcolor != [128 128 128]
      AND pcolor != [102 51 0]
      AND pcolor != [51 102 0]
      AND pxcor < 12 AND pcolor != green
      AND pycor < water_level - 16] [set pcolor blue]
  ]
  create-turtles plant_life [                                                                      ;creates a couple randomly placed plants
    setxy 13 -3
    set shape "plant"
    set color [21 207 76]
    set size 3
    set heading 90
    fd random 7
    ]
  ask n-of (salinity / 1.5) patches with [pcolor = 105][sprout 1[set shape "circle"
       set size 0.225
       set color white
       set heading random 360]]                                                                    ;creates salt particles to indicate salinity
  reset-ticks
end

to start
  tick
  wait .5
  ask turtles with [color = white][                                                                ;random salt particle movement
     set heading random 360
       if patch-ahead 2 != nobody [
          if [pcolor] of patch-ahead 2 != 105 [back 2]
          ]
      forward 1
      ]
  if material = "Ground" [ set material_toughness 1]                                               ;sets up material based durability value
  if material = "Gripper System" [ set material_toughness 2]
  if material = "Rock" [set material_toughness 1.25]
  if material = "Concrete" [set material_toughness 1.5]
  if ticks / ( material_toughness * 2) / ( plant_life * .75 ) * ( salinity * .5) * ( water_level * 2) * ( rain_intensity * .2) / 45 >= 100 [ ; calculation for levee durability, when 0, flood the levee
    let break_height -4                                                                            ;creates a variable to hold the level at which the water is supposed to break
    if water_level < 14 [
      set break_height (water_level - 16)
    ]
    ask patches [set pcolor scale-color 86 (pycor) -20 20 ] show shade-of? blue red                ;recreates gradient, effectively clears the map
    ask patches with [pycor < water_level - 16 AND pxcor < 6][set pcolor blue]
    if material = "Gripper System" [ask patches with [pycor <= break_height AND pxcor >= 6][set pcolor [51 102 0]]]
    if material = "Ground" [ask patches with [pycor <= break_height  AND pxcor >= 6][set pcolor [102 51 0]]]
    if material = "Rock" [ ask patches with [pycor <= break_height AND pxcor >= 6][set pcolor [64 64 64]]]
    if material = "Concrete" [ ask patches with [pycor <= break_height  AND pxcor >= 6][set pcolor [128 128 128]]]
    ask patches with [pycor <= break_height  AND pxcor >= 12][set pcolor brown]
    ask patches with [pycor <= water_level - 16 AND pycor >= break_height ][set pcolor blue]
    ask turtles with [color != white AND color != blue ][die]
  ]
  if water_level > 17 [                                                                             ;if water level is above a certain point, flood the levee
    ask patches with [pcolor = [64 64 64]
                OR pcolor = [128 128 128]
                OR pcolor = [102 51 0]
                OR pcolor = [51 102 0]
                OR pcolor = brown
                AND pycor > -4][set pcolor blue ]
    ask turtles with [color != white][die]

  ]
   if count rains < rain_intensity [                                                                ; determines amount of rain water droplets at once
      create-rains 1 [
      set shape "drop"
      set heading 180
      set color blue
      set size .75
      setxy random-xcor 15
    ]
  ]
   ask rains [                                                                                       ;controls rain movement
    if ycor >= -14 [fd 4]
    if ycor <= water_level - 16 [die]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
615
75
1158
535
20
16
13.0
1
10
1
1
1
0
0
0
1
-20
20
-16
16
0
0
1
ticks
30.0

BUTTON
75
107
173
140
animation
animation\n
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
183
109
283
142
NIL
construction
T
1
T
TURTLE
NIL
C
NIL
NIL
1

BUTTON
178
151
287
184
NIL
reinforcement
T
1
T
OBSERVER
NIL
R
NIL
NIL
1

BUTTON
183
196
285
229
NIL
maintenance
T
1
T
OBSERVER
NIL
M
NIL
NIL
1

BUTTON
302
196
380
229
NIL
pumping
T
1
T
OBSERVER
NIL
P
NIL
NIL
1

BUTTON
31
298
117
331
NIL
simulation
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
143
302
316
335
water_level
water_level
0
20
16
1
1
feet
HORIZONTAL

BUTTON
34
341
98
375
NIL
start
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
337
295
475
340
material
material
"Gripper System" "Concrete" "Rock" "Ground"
3

SLIDER
148
350
320
383
salinity
salinity
1
50
42
1
1
ppt
HORIZONTAL

MONITOR
1067
102
1154
147
% DECAY
ticks / ( material_toughness * 2) / ( plant_life * .75 ) * ( salinity * .5) * ( water_level * 2) * ( rain_intensity * .2) / 45
0
1
11

TEXTBOX
1173
103
1323
145
% Decay indicates how broken down the levee is! If it hits 100%, the levee will break.
11
56.0
0

SLIDER
147
404
319
437
rain_intensity
rain_intensity
1
10
7
1
1
NIL
HORIZONTAL

TEXTBOX
334
401
484
443
1 intensity = drought \n5 intensity = average rainfall\n10 intensity = flood level
11
66.0
1

SLIDER
146
452
318
485
plant_life
plant_life
1
5
2
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

An animation showing the process by which a levee is built, reinforced and maintained, coupled with a simulation showing the effects of environmental factors and construction on structural integrity.

## HOW IT WORKS
ANIMATION creates the playing field and the turtles involved in it at specific coordinates, initializes background.Pressing CONSTRUCTION, MAINTENANCE, REINFORCEMENT and PUMPING in that order causes the turtles to move in specific ways to act out the animation.

SIMULATION creates a separate view with the levee and water being made out of patches and creates a series of turtles that represent salt in the water. Using the sliders and selection box edits the variables that are used to determine how long it will take the levee to decay. Hitting START will then run the simulation until the levee is destroyed. Once the levee is destroyed, the simulation can be restarted by hitting SIMULATION again

## HOW TO USE IT

To start the animation, just hit ANIMATION and then press the buttons from top to bottom as each step is finished. Use PUMPING to remove excess groundwater.

SIMULATION initializes the simulation with the variables entered. START runs the simulation.

## THINGS TO NOTICE

ANIMATION: notice the relationships between water level and levee height, and the relationship between ground subsidence and lowering of groundwater height.

SIMULATION: take note of relationships between all of the slider variables, the materials and the rate of decay of the levee. Which variables increase durability? Which variables decrease it? Which materials are most durable?

## THINGS TO TRY

Try minimizing and maximizing the sliders with each of the different materials, note how many ticks it takes for different configurations to break.

## EXTENDING THE MODEL

Visually, add more things going on, show signs of decay as things go on. For the simulation, add more variables/adjust their values within the decay calculation to fine tune the rate of decay to make it closer to reality

## NETLOGO FEATURES

Used turtles instead of patches to make the animation have fairly high visual fidelity without needing a high resolution
used patches to make a dynamic environment in the simulation in order to allow for the enviroment to be aware of the things around it.

## CREDITS

Created as part of a group project at the Lawrence Livermore National Lab Computer Simulation Student Research Opportunity by Shane McDonald, Prahbjot Dhatt, Aljon Viray, Farhan Saeed Amy Bezek, Maya Netto, Joshua Tapia, Kristopher Ibale, Logan Throne
@#$#@#$#@
default
true
0
Rectangle -7500403 false true 120 75 180 255

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cloud
false
3
Circle -1 true false 88 33 94
Circle -1 true false 20 81 108
Circle -1 true false 161 101 127
Circle -1 true false 15 135 120
Circle -1 true false 75 120 150
Circle -1 true false 163 48 94
Circle -1 true false 103 78 94
Circle -13840069 true false 75 120 30
Circle -13840069 true false 150 105 30
Line -16777216 false 105 210 210 165
Circle -1 true false 60 90 60
Circle -1 true false 96 51 108
Circle -1 true false 66 126 108
Circle -1 true false 133 103 95
Circle -7500403 true false 15 135 120
Circle -1 true false 30 120 120
Circle -7500403 true false 75 120 150
Circle -1 true false 75 105 150
Circle -7500403 true false 15 75 120
Circle -1 true false 30 90 120

cloud1
false
0
Circle -1 true false 88 33 94
Circle -1 true false 20 81 108
Circle -1 true false 161 101 127
Circle -1 true false 15 135 120
Circle -1 true false 75 120 150
Circle -1 true false 163 48 94
Circle -1 true false 103 78 94
Circle -13791810 true false 75 120 30
Circle -13791810 true false 165 120 30
Line -16777216 false 105 195 180 195
Line -16777216 false 180 210 180 180
Line -16777216 false 105 180 105 210

cloud2
false
2
Circle -1 true false 88 33 94
Circle -1 true false 20 81 108
Circle -1 true false 161 101 127
Circle -1 true false 15 135 120
Circle -1 true false 75 120 150
Circle -1 true false 163 48 94
Circle -1 true false 103 78 94
Circle -5825686 false false 75 120 30
Circle -14835848 true false 75 120 30
Circle -14835848 true false 180 105 30
Circle -5825686 false false 108 168 85
Circle -2064490 true false 103 163 92
Circle -2674135 true false 120 195 60
Circle -1 true false 53 68 134
Circle -1 true false 88 133 124
Circle -1 true false 105 60 150
Circle -7500403 true false 163 103 124
Circle -1 true false 120 75 150
Circle -7500403 true false 75 120 150
Circle -1 true false 75 105 150

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

drop
false
0
Circle -7500403 true true 73 133 152
Polygon -7500403 true true 219 181 205 152 185 120 174 95 163 64 156 37 149 7 147 166
Polygon -7500403 true true 79 182 95 152 115 120 126 95 137 64 144 37 150 6 154 165

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flatbed
false
0
Rectangle -7500403 true true 30 164 210 194
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 79 173 42
Circle -7500403 false true 79 173 42
Circle -7500403 false true 234 174 42
Rectangle -7500403 true true 30 136 38 168
Polygon -7500403 true true 45 143 36 154 43 165 54 165 57 152 46 145 45 145
Polygon -7500403 true true 67 144 58 155 65 166 76 166 79 153 68 146 67 146
Polygon -7500403 true true 91 144 82 155 89 166 100 166 103 153 92 146 91 146
Polygon -7500403 true true 77 130 68 141 75 152 86 152 89 139 78 132 77 132
Polygon -7500403 true true 56 129 47 140 54 151 65 151 68 138 57 131 56 131
Polygon -7500403 true true 114 144 105 155 112 166 123 166 126 153 115 146 114 146
Polygon -7500403 true true 100 130 91 141 98 152 109 152 112 139 101 132 100 132

flatbed_left
false
0
Rectangle -7500403 true true 90 164 270 194
Polygon -7500403 true true 4 193 4 150 41 134 56 104 92 104 93 194
Rectangle -1 true false 105 60 105 105
Polygon -16777216 true false 62 112 48 141 81 141 82 112
Circle -16777216 true false 24 174 42
Rectangle -7500403 true true 86 185 119 194
Circle -16777216 true false 179 173 42
Circle -7500403 false true 179 173 42
Circle -7500403 false true 24 174 42
Rectangle -7500403 true true 262 136 270 168
Polygon -7500403 true true 255 143 264 154 257 165 246 165 243 152 254 145 255 145
Polygon -7500403 true true 233 144 242 155 235 166 224 166 221 153 232 146 233 146
Polygon -7500403 true true 209 144 218 155 211 166 200 166 197 153 208 146 209 146
Polygon -7500403 true true 223 130 232 141 225 152 214 152 211 139 222 132 223 132
Polygon -7500403 true true 244 129 253 140 246 151 235 151 232 138 243 131 244 131
Polygon -7500403 true true 186 144 195 155 188 166 177 166 174 153 185 146 186 146
Polygon -7500403 true true 200 130 209 141 202 152 191 152 188 139 199 132 200 132

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

ground
true
0
Rectangle -6459832 true false 30 105 270 195

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

levee-left
false
0
Polygon -6459832 true false 150 30 30 255 210 255

levee-left-rocky
false
13
Polygon -6459832 true false 150 31 30 256 210 256
Polygon -7500403 true false 46 228 58 229 66 237 63 251 46 254 34 242
Polygon -7500403 true false 62 203 74 204 82 212 79 226 62 229 50 217
Polygon -7500403 true false 85 227 97 228 105 236 102 250 85 253 73 241
Polygon -7500403 true false 105 173 117 174 125 182 122 196 105 199 93 187
Polygon -7500403 true false 71 171 83 172 91 180 88 194 71 197 59 185
Polygon -7500403 true false 97 201 109 202 117 210 114 224 97 227 85 215
Polygon -7500403 true false 82 142 94 143 102 151 99 165 82 168 70 156
Polygon -7500403 true false 100 116 112 117 120 125 117 139 100 142 88 130
Polygon -7500403 true false 114 139 126 140 134 148 131 162 114 165 102 153
Polygon -7500403 true false 119 88 131 89 139 97 136 111 119 114 107 102
Polygon -7500403 true false 133 114 145 115 153 123 150 137 133 140 121 128
Polygon -7500403 true false 130 60 142 61 150 69 147 83 130 86 118 74

levee-right
false
0
Polygon -6459832 true false 150 30 255 255 90 255

levee-right-rocky
false
13
Polygon -6459832 true false 150 31 270 256 90 256
Polygon -7500403 true false 254 228 242 229 234 237 237 251 254 254 266 242
Polygon -7500403 true false 238 203 226 204 218 212 221 226 238 229 250 217
Polygon -7500403 true false 215 227 203 228 195 236 198 250 215 253 227 241
Polygon -7500403 true false 195 173 183 174 175 182 178 196 195 199 207 187
Polygon -7500403 true false 229 171 217 172 209 180 212 194 229 197 241 185
Polygon -7500403 true false 203 201 191 202 183 210 186 224 203 227 215 215
Polygon -7500403 true false 218 142 206 143 198 151 201 165 218 168 230 156
Polygon -7500403 true false 200 116 188 117 180 125 183 139 200 142 212 130
Polygon -7500403 true false 186 139 174 140 166 148 169 162 186 165 198 153
Polygon -7500403 true false 181 88 169 89 161 97 164 111 181 114 193 102
Polygon -7500403 true false 167 114 155 115 147 123 150 137 167 140 179 128
Polygon -7500403 true false 170 60 158 61 150 69 153 83 170 86 182 74

leveeleft
true
0
Polygon -7500403 true true 150 165 90 165 150 45 150 165

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

pump
true
0
Rectangle -7500403 true true 120 105 165 225
Rectangle -7500403 true true -135 105 165 135

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -6459832 true false 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

sun
true
2
Circle -1184463 false false 86 86 127
Circle -1184463 true false 83 83 134
Circle -955883 false true 83 83 134

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

water
true
0
Rectangle -7500403 true true 75 105 240 195

water-sim
true
0
Rectangle -7500403 true true -75 135 345 180

watertable
true
0
Rectangle -7500403 true true 15 120 285 180
Polygon -7500403 true true 285 180 330 120 285 120 285 180
Polygon -7500403 true true 15 180 -30 120 15 120 15 180

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
