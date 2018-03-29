Shader "Animated/Built-in/Transparent/Parallax Specular" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 0)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_Parallax ("Height", Range (0.005, 0.08)) = 0.02
	_MainTex ("Base (RGB) TransGloss (A)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_PanMT("Pan <Base (RGB) TransGloss (A) & Normalmap> (Speed(XY))", Vector) = (0,0,0,0)
	_RotMT("Rot <Base (RGB) TransGloss (A) & Normalmap> (Pivot(XY), Angle Speed(Z), Angle(W))", Vector) = (0.5,0.5,0,0)
	_ParallaxMap ("Heightmap (A)", 2D) = "black" {}
	_PanPM("Pan <Heightmap (A)> (Speed(XY))", Vector) = (0,0,0,0)
	_RotPM("Rot <Heightmap (A)> (Pivot(XY), Angle Speed(Z), Angle(W))", Vector) = (0.5,0.5,0,0)
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 600
	
	Alphatest Greater 0 ZWrite Off ColorMask RGB
	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha
Program "vp" {
// Vertex combos: 4
//   opengl - ALU: 20 to 75
//   d3d9 - ALU: 21 to 78
//   d3d11 - ALU: 18 to 63, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 22 [unity_Scale]
Vector 23 [_MainTex_ST]
Vector 24 [_BumpMap_ST]
"3.0-!!ARBvp1.0
# 44 ALU
PARAM c[25] = { { 1 },
		state.matrix.mvp,
		program.local[5..24] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[22].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[17];
DP4 R2.y, R0, c[16];
DP4 R2.x, R0, c[15];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[20];
DP4 R3.y, R1, c[19];
DP4 R3.x, R1, c[18];
ADD R2.xyz, R2, R3;
MAD R0.x, R0, R0, -R0.y;
MUL R3.xyz, R0.x, c[21];
MOV R1.xyz, vertex.attrib[14];
MUL R0.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R1.zxyw, -R0;
ADD result.texcoord[3].xyz, R2, R3;
MOV R0.xyz, c[13];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[22].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[14];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
DP3 result.texcoord[1].y, R0, R2;
DP3 result.texcoord[2].y, R2, R3;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP3 result.texcoord[2].z, vertex.normal, R3;
DP3 result.texcoord[2].x, vertex.attrib[14], R3;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[24].xyxy, c[24];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[23], c[23].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 44 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 21 [unity_Scale]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
"vs_3_0
; 47 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c24, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c21.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c24.x
dp4 r2.z, r0, c16
dp4 r2.y, r0, c15
dp4 r2.x, r0, c14
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c19
dp4 r3.y, r1, c18
dp4 r3.x, r1, c17
add r1.xyz, r2, r3
mad r0.x, r0, r0, -r0.y
mul r2.xyz, r0.x, c20
add o4.xyz, r1, r2
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c13, r0
mov r0, c9
mov r1.w, c24.x
mov r1.xyz, c12
dp4 r4.y, c13, r0
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c21.w, -v0
mov r1, c8
dp4 r4.x, c13, r1
dp3 o2.y, r2, r3
dp3 o3.y, r3, r4
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o3.z, v2, r4
dp3 o3.x, v1, r4
mad o1.zw, v3.xyxy, c23.xyxy, c23
mad o1.xy, v3, c22, c22.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 176 used size, 12 vars
Vector 144 [_MainTex_ST] 4
Vector 160 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 41 instructions, 4 temp regs, 0 temp arrays:
// ALU 39 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedkdeffldhmjmfaanpdaeiccmfelnbjcoiabaaaaaanaahaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcdeagaaaaeaaaabaa
inabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacaeaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaakaaaaaa
kgiocaaaaaaaaaaaakaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaa
cgbjbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaa
abaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgbpbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaa
adaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaacaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaacaaaaaaaaaaaaaa
egiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
baaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaa
acaaaaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaa
aaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaa
abeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaacgaaaaaa
egaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaachaaaaaa
egaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaaciaaaaaa
egaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaa
aaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaa
acaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaa
acaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaa
acaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaa
diaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaak
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaa
aaaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_8 = tmpvar_1.xyz;
  tmpvar_9 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_8.x;
  tmpvar_10[0].y = tmpvar_9.x;
  tmpvar_10[0].z = tmpvar_2.x;
  tmpvar_10[1].x = tmpvar_8.y;
  tmpvar_10[1].y = tmpvar_9.y;
  tmpvar_10[1].z = tmpvar_2.y;
  tmpvar_10[2].x = tmpvar_8.z;
  tmpvar_10[2].y = tmpvar_9.z;
  tmpvar_10[2].z = tmpvar_2.z;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = (tmpvar_7 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_14;
  mediump vec4 normal_15;
  normal_15 = tmpvar_13;
  highp float vC_16;
  mediump vec3 x3_17;
  mediump vec3 x2_18;
  mediump vec3 x1_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHAr, normal_15);
  x1_19.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAg, normal_15);
  x1_19.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAb, normal_15);
  x1_19.z = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (normal_15.xyzz * normal_15.yzzx);
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHBr, tmpvar_23);
  x2_18.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBg, tmpvar_23);
  x2_18.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBb, tmpvar_23);
  x2_18.z = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = ((normal_15.x * normal_15.x) - (normal_15.y * normal_15.y));
  vC_16 = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (unity_SHC.xyz * vC_16);
  x3_17 = tmpvar_28;
  tmpvar_14 = ((x1_19 + x2_18) + x3_17);
  shlight_3 = tmpvar_14;
  tmpvar_6 = shlight_3;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_10 * (((_World2Object * tmpvar_12).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_3.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_ParallaxMap, tmpvar_3).w;
  h_2 = tmpvar_4;
  highp vec2 tmpvar_5;
  mediump float height_6;
  height_6 = _Parallax;
  mediump vec3 viewDir_7;
  viewDir_7 = xlv_TEXCOORD1;
  highp vec3 v_8;
  mediump float tmpvar_9;
  tmpvar_9 = ((h_2 * height_6) - (height_6 / 2.0));
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(viewDir_7);
  v_8 = tmpvar_10;
  v_8.z = (v_8.z + 0.42);
  tmpvar_5 = (tmpvar_9 * (v_8.xy / v_8.z));
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xy + tmpvar_5);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.zw + tmpvar_5);
  highp vec2 tmpvar_13;
  tmpvar_13.x = ((_RotMT.x - (((tmpvar_11.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_11.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_13.y = ((_RotMT.y - (((tmpvar_11.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_11.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, tmpvar_13);
  lowp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14.xyz * _Color.xyz);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_14.w * _Color.w);
  highp vec2 tmpvar_17;
  tmpvar_17.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_17.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 tmpvar_18;
  tmpvar_18 = ((texture2D (_BumpMap, tmpvar_17).xyz * 2.0) - 1.0);
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize(xlv_TEXCOORD1);
  mediump vec3 viewDir_20;
  viewDir_20 = tmpvar_19;
  lowp vec4 c_21;
  highp float nh_22;
  lowp float tmpvar_23;
  tmpvar_23 = max (0.0, dot (tmpvar_18, xlv_TEXCOORD2));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, dot (tmpvar_18, normalize((xlv_TEXCOORD2 + viewDir_20))));
  nh_22 = tmpvar_24;
  mediump float arg1_25;
  arg1_25 = (_Shininess * 128.0);
  highp float tmpvar_26;
  tmpvar_26 = (pow (nh_22, arg1_25) * tmpvar_14.w);
  highp vec3 tmpvar_27;
  tmpvar_27 = ((((tmpvar_15 * _LightColor0.xyz) * tmpvar_23) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_26)) * 2.0);
  c_21.xyz = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (tmpvar_16 + ((_LightColor0.w * _SpecColor.w) * tmpvar_26));
  c_21.w = tmpvar_28;
  c_1.xyz = (c_21.xyz + (tmpvar_15 * xlv_TEXCOORD3));
  c_1.w = tmpvar_16;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_8 = tmpvar_1.xyz;
  tmpvar_9 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_8.x;
  tmpvar_10[0].y = tmpvar_9.x;
  tmpvar_10[0].z = tmpvar_2.x;
  tmpvar_10[1].x = tmpvar_8.y;
  tmpvar_10[1].y = tmpvar_9.y;
  tmpvar_10[1].z = tmpvar_2.y;
  tmpvar_10[2].x = tmpvar_8.z;
  tmpvar_10[2].y = tmpvar_9.z;
  tmpvar_10[2].z = tmpvar_2.z;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = (tmpvar_7 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_14;
  mediump vec4 normal_15;
  normal_15 = tmpvar_13;
  highp float vC_16;
  mediump vec3 x3_17;
  mediump vec3 x2_18;
  mediump vec3 x1_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHAr, normal_15);
  x1_19.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAg, normal_15);
  x1_19.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAb, normal_15);
  x1_19.z = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (normal_15.xyzz * normal_15.yzzx);
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHBr, tmpvar_23);
  x2_18.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBg, tmpvar_23);
  x2_18.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBb, tmpvar_23);
  x2_18.z = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = ((normal_15.x * normal_15.x) - (normal_15.y * normal_15.y));
  vC_16 = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (unity_SHC.xyz * vC_16);
  x3_17 = tmpvar_28;
  tmpvar_14 = ((x1_19 + x2_18) + x3_17);
  shlight_3 = tmpvar_14;
  tmpvar_6 = shlight_3;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_10 * (((_World2Object * tmpvar_12).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_3.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_ParallaxMap, tmpvar_3).w;
  h_2 = tmpvar_4;
  highp vec2 tmpvar_5;
  mediump float height_6;
  height_6 = _Parallax;
  mediump vec3 viewDir_7;
  viewDir_7 = xlv_TEXCOORD1;
  highp vec3 v_8;
  mediump float tmpvar_9;
  tmpvar_9 = ((h_2 * height_6) - (height_6 / 2.0));
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(viewDir_7);
  v_8 = tmpvar_10;
  v_8.z = (v_8.z + 0.42);
  tmpvar_5 = (tmpvar_9 * (v_8.xy / v_8.z));
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xy + tmpvar_5);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.zw + tmpvar_5);
  highp vec2 tmpvar_13;
  tmpvar_13.x = ((_RotMT.x - (((tmpvar_11.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_11.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_13.y = ((_RotMT.y - (((tmpvar_11.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_11.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, tmpvar_13);
  lowp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14.xyz * _Color.xyz);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_14.w * _Color.w);
  highp vec2 tmpvar_17;
  tmpvar_17.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_17.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 normal_18;
  normal_18.xy = ((texture2D (_BumpMap, tmpvar_17).wy * 2.0) - 1.0);
  normal_18.z = sqrt((1.0 - clamp (dot (normal_18.xy, normal_18.xy), 0.0, 1.0)));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize(xlv_TEXCOORD1);
  mediump vec3 viewDir_20;
  viewDir_20 = tmpvar_19;
  lowp vec4 c_21;
  highp float nh_22;
  lowp float tmpvar_23;
  tmpvar_23 = max (0.0, dot (normal_18, xlv_TEXCOORD2));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, dot (normal_18, normalize((xlv_TEXCOORD2 + viewDir_20))));
  nh_22 = tmpvar_24;
  mediump float arg1_25;
  arg1_25 = (_Shininess * 128.0);
  highp float tmpvar_26;
  tmpvar_26 = (pow (nh_22, arg1_25) * tmpvar_14.w);
  highp vec3 tmpvar_27;
  tmpvar_27 = ((((tmpvar_15 * _LightColor0.xyz) * tmpvar_23) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_26)) * 2.0);
  c_21.xyz = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (tmpvar_16 + ((_LightColor0.w * _SpecColor.w) * tmpvar_26));
  c_21.w = tmpvar_28;
  c_1.xyz = (c_21.xyz + (tmpvar_15 * xlv_TEXCOORD3));
  c_1.w = tmpvar_16;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    lowp vec3 lightDir;
    lowp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
#line 393
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
#line 397
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 408
#line 433
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
#line 453
#line 82
highp vec3 ObjSpaceLightDir( in highp vec4 v ) {
    highp vec3 objSpaceLightPos = (_World2Object * _WorldSpaceLightPos0).xyz;
    return objSpaceLightPos.xyz;
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 435
v2f_surf vert_surf( in appdata_full v ) {
    #line 437
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
    #line 441
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 binormal = (cross( v.normal, v.tangent.xyz) * v.tangent.w);
    highp mat3 rotation = xll_transpose_mf3x3(mat3( v.tangent.xyz, binormal, v.normal));
    highp vec3 lightDir = (rotation * ObjSpaceLightDir( v.vertex));
    #line 445
    o.lightDir = lightDir;
    highp vec3 viewDirForLight = (rotation * ObjSpaceViewDir( v.vertex));
    o.viewDir = viewDirForLight;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    #line 449
    o.vlight = shlight;
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    lowp vec3 lightDir;
    lowp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
#line 393
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
#line 397
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 408
#line 433
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
#line 453
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 166
highp vec2 ParallaxOffset( in mediump float h, in mediump float height, in mediump vec3 viewDir ) {
    h = ((h * height) - (height / 2.0));
    highp vec3 v = normalize(viewDir);
    #line 170
    v.z += 0.42;
    return (h * (v.xy / v.z));
}
#line 272
lowp vec3 UnpackNormal( in lowp vec4 packednormal ) {
    #line 274
    return ((packednormal.xyz * 2.0) - 1.0);
}
#line 408
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanPM = vec2( ((_RotPM.x - (((IN.uv_BumpMap.x - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y)), ((_RotPM.y - (((IN.uv_BumpMap.x - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y)));
    mediump float h = texture( _ParallaxMap, UV_PanPM).w;
    #line 412
    highp vec2 offset = ParallaxOffset( h, _Parallax, IN.viewDir);
    IN.uv_MainTex += offset;
    IN.uv_BumpMap += offset;
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    #line 416
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    o.Albedo = (tex.xyz * _Color.xyz);
    o.Gloss = tex.w;
    o.Alpha = (tex.w * _Color.w);
    #line 420
    o.Specular = _Shininess;
    highp vec2 UV_PanBM = vec2( ((_RotMT.x - (((IN.uv_BumpMap.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_BumpMap.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    o.Normal = UnpackNormal( texture( _BumpMap, UV_PanBM));
}
#line 453
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 457
    surfIN.uv_BumpMap = IN.pack0.zw;
    surfIN.viewDir = IN.viewDir;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 461
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 465
    surf( surfIN, o);
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    c = LightingBlinnPhong( o, IN.lightDir, normalize(IN.viewDir), atten);
    #line 469
    c.xyz += (o.Albedo * IN.vlight);
    c.w = o.Alpha;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Vector 15 [unity_Scale]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
Vector 18 [_BumpMap_ST]
"3.0-!!ARBvp1.0
# 20 ALU
PARAM c[19] = { { 1 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[13];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[15].w, -vertex.position;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 20 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 13 [unity_Scale]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
Vector 16 [_BumpMap_ST]
"vs_3_0
; 21 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c17, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r1.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c17.x
dp4 r2.z, r0, c10
dp4 r2.x, r0, c8
dp4 r2.y, r0, c9
mad r0.xyz, r2, c13.w, -v0
dp3 o2.y, r0, r1
dp3 o2.z, v2, r0
dp3 o2.x, r0, v1
mad o1.zw, v3.xyxy, c16.xyxy, c16
mad o1.xy, v3, c15, c15.zwzw
mad o3.xy, v4, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 192 used size, 13 vars
Vector 144 [unity_LightmapST] 4
Vector 160 [_MainTex_ST] 4
Vector 176 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 19 instructions, 2 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedonkpgfodejcbnkpoannilhhbpbhaepioabaaaaaanaaeaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
emadaaaaeaaaabaandaaaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaae
egiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaakaaaaaaogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaa
alaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaa
dcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaia
ebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaa
abaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaa
acaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaa
agiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaa
aaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaacaaaaaabdaaaaaa
dcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaabeaaaaaa
egbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
dcaaaaaldccabaaaadaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaajaaaaaa
ogikcaaaaaaaaaaaajaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _Parallax;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_3.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_ParallaxMap, tmpvar_3).w;
  h_2 = tmpvar_4;
  mediump float height_5;
  height_5 = _Parallax;
  mediump vec3 viewDir_6;
  viewDir_6 = xlv_TEXCOORD1;
  highp vec3 v_7;
  mediump float tmpvar_8;
  tmpvar_8 = ((h_2 * height_5) - (height_5 / 2.0));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize(viewDir_6);
  v_7 = tmpvar_9;
  v_7.z = (v_7.z + 0.42);
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy + (tmpvar_8 * (v_7.xy / v_7.z)));
  highp vec2 tmpvar_11;
  tmpvar_11.x = ((_RotMT.x - (((tmpvar_10.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_10.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_11.y = ((_RotMT.y - (((tmpvar_10.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_10.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  c_1.xyz = ((tmpvar_12.xyz * _Color.xyz) * (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz));
  c_1.w = (tmpvar_12.w * _Color.w);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _Parallax;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_3.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_ParallaxMap, tmpvar_3).w;
  h_2 = tmpvar_4;
  highp vec2 tmpvar_5;
  mediump float height_6;
  height_6 = _Parallax;
  mediump vec3 viewDir_7;
  viewDir_7 = xlv_TEXCOORD1;
  highp vec3 v_8;
  mediump float tmpvar_9;
  tmpvar_9 = ((h_2 * height_6) - (height_6 / 2.0));
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(viewDir_7);
  v_8 = tmpvar_10;
  v_8.z = (v_8.z + 0.42);
  tmpvar_5 = (tmpvar_9 * (v_8.xy / v_8.z));
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xy + tmpvar_5);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.zw + tmpvar_5);
  highp vec2 tmpvar_13;
  tmpvar_13.x = ((_RotMT.x - (((tmpvar_11.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_11.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_13.y = ((_RotMT.y - (((tmpvar_11.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_11.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, tmpvar_13);
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_15.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 normal_16;
  normal_16.xy = ((texture2D (_BumpMap, tmpvar_15).wy * 2.0) - 1.0);
  normal_16.z = sqrt((1.0 - clamp (dot (normal_16.xy, normal_16.xy), 0.0, 1.0)));
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  c_1.xyz = ((tmpvar_14.xyz * _Color.xyz) * ((8.0 * tmpvar_17.w) * tmpvar_17.xyz));
  c_1.w = (tmpvar_14.w * _Color.w);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
#line 393
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
#line 397
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 408
#line 432
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D unity_Lightmap;
#line 82
highp vec3 ObjSpaceLightDir( in highp vec4 v ) {
    highp vec3 objSpaceLightPos = (_World2Object * _WorldSpaceLightPos0).xyz;
    return objSpaceLightPos.xyz;
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 435
v2f_surf vert_surf( in appdata_full v ) {
    #line 437
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
    #line 441
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 binormal = (cross( v.normal, v.tangent.xyz) * v.tangent.w);
    highp mat3 rotation = xll_transpose_mf3x3(mat3( v.tangent.xyz, binormal, v.normal));
    #line 445
    highp vec3 lightDir = (rotation * ObjSpaceLightDir( v.vertex));
    highp vec3 viewDirForLight = (rotation * ObjSpaceViewDir( v.vertex));
    o.viewDir = viewDirForLight;
    #line 449
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
#line 393
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
#line 397
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 408
#line 432
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 166
highp vec2 ParallaxOffset( in mediump float h, in mediump float height, in mediump vec3 viewDir ) {
    h = ((h * height) - (height / 2.0));
    highp vec3 v = normalize(viewDir);
    #line 170
    v.z += 0.42;
    return (h * (v.xy / v.z));
}
#line 272
lowp vec3 UnpackNormal( in lowp vec4 packednormal ) {
    #line 274
    return ((packednormal.xyz * 2.0) - 1.0);
}
#line 408
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanPM = vec2( ((_RotPM.x - (((IN.uv_BumpMap.x - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y)), ((_RotPM.y - (((IN.uv_BumpMap.x - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y)));
    mediump float h = texture( _ParallaxMap, UV_PanPM).w;
    #line 412
    highp vec2 offset = ParallaxOffset( h, _Parallax, IN.viewDir);
    IN.uv_MainTex += offset;
    IN.uv_BumpMap += offset;
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    #line 416
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    o.Albedo = (tex.xyz * _Color.xyz);
    o.Gloss = tex.w;
    o.Alpha = (tex.w * _Color.w);
    #line 420
    o.Specular = _Shininess;
    highp vec2 UV_PanBM = vec2( ((_RotMT.x - (((IN.uv_BumpMap.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_BumpMap.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    o.Normal = UnpackNormal( texture( _BumpMap, UV_PanBM));
}
#line 452
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 454
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_BumpMap = IN.pack0.zw;
    surfIN.viewDir = IN.viewDir;
    #line 458
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 462
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp float atten = 1.0;
    #line 466
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec3 lm = DecodeLightmap( lmtex);
    c.xyz += (o.Albedo * lm);
    #line 470
    c.w = o.Alpha;
    c.w = o.Alpha;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Vector 15 [unity_Scale]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
Vector 18 [_BumpMap_ST]
"3.0-!!ARBvp1.0
# 20 ALU
PARAM c[19] = { { 1 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[13];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[15].w, -vertex.position;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 20 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 13 [unity_Scale]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
Vector 16 [_BumpMap_ST]
"vs_3_0
; 21 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c17, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r1.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c17.x
dp4 r2.z, r0, c10
dp4 r2.x, r0, c8
dp4 r2.y, r0, c9
mad r0.xyz, r2, c13.w, -v0
dp3 o2.y, r0, r1
dp3 o2.z, v2, r0
dp3 o2.x, r0, v1
mad o1.zw, v3.xyxy, c16.xyxy, c16
mad o1.xy, v3, c15, c15.zwzw
mad o3.xy, v4, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 192 used size, 13 vars
Vector 144 [unity_LightmapST] 4
Vector 160 [_MainTex_ST] 4
Vector 176 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 19 instructions, 2 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedonkpgfodejcbnkpoannilhhbpbhaepioabaaaaaanaaeaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
emadaaaaeaaaabaandaaaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaae
egiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaakaaaaaaogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaa
alaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaa
dcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaia
ebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaa
abaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaa
acaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaa
agiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaa
aaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaacaaaaaabdaaaaaa
dcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaabeaaaaaa
egbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
dcaaaaaldccabaaaadaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaajaaaaaa
ogikcaaaaaaaaaaaajaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_3.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_ParallaxMap, tmpvar_3).w;
  h_2 = tmpvar_4;
  highp vec2 tmpvar_5;
  mediump float height_6;
  height_6 = _Parallax;
  mediump vec3 viewDir_7;
  viewDir_7 = xlv_TEXCOORD1;
  highp vec3 v_8;
  mediump float tmpvar_9;
  tmpvar_9 = ((h_2 * height_6) - (height_6 / 2.0));
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(viewDir_7);
  v_8 = tmpvar_10;
  v_8.z = (v_8.z + 0.42);
  tmpvar_5 = (tmpvar_9 * (v_8.xy / v_8.z));
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xy + tmpvar_5);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.zw + tmpvar_5);
  highp vec2 tmpvar_13;
  tmpvar_13.x = ((_RotMT.x - (((tmpvar_11.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_11.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_13.y = ((_RotMT.y - (((tmpvar_11.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_11.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, tmpvar_13);
  lowp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14.xyz * _Color.xyz);
  highp vec2 tmpvar_16;
  tmpvar_16.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_16.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((texture2D (_BumpMap, tmpvar_16).xyz * 2.0) - 1.0);
  c_1.w = 0.0;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize(xlv_TEXCOORD1);
  mediump vec4 tmpvar_19;
  mediump vec3 viewDir_20;
  viewDir_20 = tmpvar_18;
  mediump vec3 specColor_21;
  highp float nh_22;
  mat3 tmpvar_23;
  tmpvar_23[0].x = 0.816497;
  tmpvar_23[0].y = -0.408248;
  tmpvar_23[0].z = -0.408248;
  tmpvar_23[1].x = 0.0;
  tmpvar_23[1].y = 0.707107;
  tmpvar_23[1].z = -0.707107;
  tmpvar_23[2].x = 0.57735;
  tmpvar_23[2].y = 0.57735;
  tmpvar_23[2].z = 0.57735;
  mediump vec3 normal_24;
  normal_24 = tmpvar_17;
  mediump vec3 scalePerBasisVector_25;
  mediump vec3 lm_26;
  lowp vec3 tmpvar_27;
  tmpvar_27 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lm_26 = tmpvar_27;
  lowp vec3 tmpvar_28;
  tmpvar_28 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD2).xyz);
  scalePerBasisVector_25 = tmpvar_28;
  lm_26 = (lm_26 * dot (clamp ((tmpvar_23 * normal_24), 0.0, 1.0), scalePerBasisVector_25));
  vec3 v_29;
  v_29.x = tmpvar_23[0].x;
  v_29.y = tmpvar_23[1].x;
  v_29.z = tmpvar_23[2].x;
  vec3 v_30;
  v_30.x = tmpvar_23[0].y;
  v_30.y = tmpvar_23[1].y;
  v_30.z = tmpvar_23[2].y;
  vec3 v_31;
  v_31.x = tmpvar_23[0].z;
  v_31.y = tmpvar_23[1].z;
  v_31.z = tmpvar_23[2].z;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, dot (tmpvar_17, normalize((normalize((((scalePerBasisVector_25.x * v_29) + (scalePerBasisVector_25.y * v_30)) + (scalePerBasisVector_25.z * v_31))) + viewDir_20))));
  nh_22 = tmpvar_32;
  highp float tmpvar_33;
  mediump float arg1_34;
  arg1_34 = (_Shininess * 128.0);
  tmpvar_33 = pow (nh_22, arg1_34);
  highp vec3 tmpvar_35;
  tmpvar_35 = (((lm_26 * _SpecColor.xyz) * tmpvar_14.w) * tmpvar_33);
  specColor_21 = tmpvar_35;
  highp vec4 tmpvar_36;
  tmpvar_36.xyz = lm_26;
  tmpvar_36.w = tmpvar_33;
  tmpvar_19 = tmpvar_36;
  c_1.xyz = specColor_21;
  mediump vec3 tmpvar_37;
  tmpvar_37 = (c_1.xyz + (tmpvar_15 * tmpvar_19.xyz));
  c_1.xyz = tmpvar_37;
  c_1.w = (tmpvar_14.w * _Color.w);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_3.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_ParallaxMap, tmpvar_3).w;
  h_2 = tmpvar_4;
  highp vec2 tmpvar_5;
  mediump float height_6;
  height_6 = _Parallax;
  mediump vec3 viewDir_7;
  viewDir_7 = xlv_TEXCOORD1;
  highp vec3 v_8;
  mediump float tmpvar_9;
  tmpvar_9 = ((h_2 * height_6) - (height_6 / 2.0));
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(viewDir_7);
  v_8 = tmpvar_10;
  v_8.z = (v_8.z + 0.42);
  tmpvar_5 = (tmpvar_9 * (v_8.xy / v_8.z));
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xy + tmpvar_5);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.zw + tmpvar_5);
  highp vec2 tmpvar_13;
  tmpvar_13.x = ((_RotMT.x - (((tmpvar_11.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_11.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_13.y = ((_RotMT.y - (((tmpvar_11.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_11.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, tmpvar_13);
  lowp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14.xyz * _Color.xyz);
  highp vec2 tmpvar_16;
  tmpvar_16.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_16.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 normal_17;
  normal_17.xy = ((texture2D (_BumpMap, tmpvar_16).wy * 2.0) - 1.0);
  normal_17.z = sqrt((1.0 - clamp (dot (normal_17.xy, normal_17.xy), 0.0, 1.0)));
  c_1.w = 0.0;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (unity_LightmapInd, xlv_TEXCOORD2);
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize(xlv_TEXCOORD1);
  mediump vec4 tmpvar_21;
  mediump vec3 viewDir_22;
  viewDir_22 = tmpvar_20;
  mediump vec3 specColor_23;
  highp float nh_24;
  mat3 tmpvar_25;
  tmpvar_25[0].x = 0.816497;
  tmpvar_25[0].y = -0.408248;
  tmpvar_25[0].z = -0.408248;
  tmpvar_25[1].x = 0.0;
  tmpvar_25[1].y = 0.707107;
  tmpvar_25[1].z = -0.707107;
  tmpvar_25[2].x = 0.57735;
  tmpvar_25[2].y = 0.57735;
  tmpvar_25[2].z = 0.57735;
  mediump vec3 normal_26;
  normal_26 = normal_17;
  mediump vec3 scalePerBasisVector_27;
  mediump vec3 lm_28;
  lowp vec3 tmpvar_29;
  tmpvar_29 = ((8.0 * tmpvar_18.w) * tmpvar_18.xyz);
  lm_28 = tmpvar_29;
  lowp vec3 tmpvar_30;
  tmpvar_30 = ((8.0 * tmpvar_19.w) * tmpvar_19.xyz);
  scalePerBasisVector_27 = tmpvar_30;
  lm_28 = (lm_28 * dot (clamp ((tmpvar_25 * normal_26), 0.0, 1.0), scalePerBasisVector_27));
  vec3 v_31;
  v_31.x = tmpvar_25[0].x;
  v_31.y = tmpvar_25[1].x;
  v_31.z = tmpvar_25[2].x;
  vec3 v_32;
  v_32.x = tmpvar_25[0].y;
  v_32.y = tmpvar_25[1].y;
  v_32.z = tmpvar_25[2].y;
  vec3 v_33;
  v_33.x = tmpvar_25[0].z;
  v_33.y = tmpvar_25[1].z;
  v_33.z = tmpvar_25[2].z;
  mediump float tmpvar_34;
  tmpvar_34 = max (0.0, dot (normal_17, normalize((normalize((((scalePerBasisVector_27.x * v_31) + (scalePerBasisVector_27.y * v_32)) + (scalePerBasisVector_27.z * v_33))) + viewDir_22))));
  nh_24 = tmpvar_34;
  highp float tmpvar_35;
  mediump float arg1_36;
  arg1_36 = (_Shininess * 128.0);
  tmpvar_35 = pow (nh_24, arg1_36);
  highp vec3 tmpvar_37;
  tmpvar_37 = (((lm_28 * _SpecColor.xyz) * tmpvar_14.w) * tmpvar_35);
  specColor_23 = tmpvar_37;
  highp vec4 tmpvar_38;
  tmpvar_38.xyz = lm_28;
  tmpvar_38.w = tmpvar_35;
  tmpvar_21 = tmpvar_38;
  c_1.xyz = specColor_23;
  mediump vec3 tmpvar_39;
  tmpvar_39 = (c_1.xyz + (tmpvar_15 * tmpvar_21.xyz));
  c_1.xyz = tmpvar_39;
  c_1.w = (tmpvar_14.w * _Color.w);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
#line 393
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
#line 397
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 408
#line 432
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 453
#line 82
highp vec3 ObjSpaceLightDir( in highp vec4 v ) {
    highp vec3 objSpaceLightPos = (_World2Object * _WorldSpaceLightPos0).xyz;
    return objSpaceLightPos.xyz;
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 435
v2f_surf vert_surf( in appdata_full v ) {
    #line 437
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
    #line 441
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 binormal = (cross( v.normal, v.tangent.xyz) * v.tangent.w);
    highp mat3 rotation = xll_transpose_mf3x3(mat3( v.tangent.xyz, binormal, v.normal));
    #line 445
    highp vec3 lightDir = (rotation * ObjSpaceLightDir( v.vertex));
    highp vec3 viewDirForLight = (rotation * ObjSpaceViewDir( v.vertex));
    o.viewDir = viewDirForLight;
    #line 449
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
vec2 xll_matrixindex_mf2x2_i (mat2 m, int i) { vec2 v; v.x=m[0][i]; v.y=m[1][i]; return v; }
vec3 xll_matrixindex_mf3x3_i (mat3 m, int i) { vec3 v; v.x=m[0][i]; v.y=m[1][i]; v.z=m[2][i]; return v; }
vec4 xll_matrixindex_mf4x4_i (mat4 m, int i) { vec4 v; v.x=m[0][i]; v.y=m[1][i]; v.z=m[2][i]; v.w=m[3][i]; return v; }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
#line 393
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
#line 397
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 408
#line 432
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 453
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 379
mediump vec4 LightingBlinnPhong_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 viewDir, in bool surfFuncWritesNormal, out mediump vec3 specColor ) {
    #line 381
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    mediump vec3 lightDir = normalize((((scalePerBasisVector.x * xll_matrixindex_mf3x3_i (unity_DirBasis, 0)) + (scalePerBasisVector.y * xll_matrixindex_mf3x3_i (unity_DirBasis, 1))) + (scalePerBasisVector.z * xll_matrixindex_mf3x3_i (unity_DirBasis, 2))));
    #line 385
    mediump vec3 h = normalize((lightDir + viewDir));
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = pow( nh, (s.Specular * 128.0));
    specColor = (((lm * _SpecColor.xyz) * s.Gloss) * spec);
    #line 389
    return vec4( lm, spec);
}
#line 166
highp vec2 ParallaxOffset( in mediump float h, in mediump float height, in mediump vec3 viewDir ) {
    h = ((h * height) - (height / 2.0));
    highp vec3 v = normalize(viewDir);
    #line 170
    v.z += 0.42;
    return (h * (v.xy / v.z));
}
#line 272
lowp vec3 UnpackNormal( in lowp vec4 packednormal ) {
    #line 274
    return ((packednormal.xyz * 2.0) - 1.0);
}
#line 408
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanPM = vec2( ((_RotPM.x - (((IN.uv_BumpMap.x - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y)), ((_RotPM.y - (((IN.uv_BumpMap.x - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y)));
    mediump float h = texture( _ParallaxMap, UV_PanPM).w;
    #line 412
    highp vec2 offset = ParallaxOffset( h, _Parallax, IN.viewDir);
    IN.uv_MainTex += offset;
    IN.uv_BumpMap += offset;
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    #line 416
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    o.Albedo = (tex.xyz * _Color.xyz);
    o.Gloss = tex.w;
    o.Alpha = (tex.w * _Color.w);
    #line 420
    o.Specular = _Shininess;
    highp vec2 UV_PanBM = vec2( ((_RotMT.x - (((IN.uv_BumpMap.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_BumpMap.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    o.Normal = UnpackNormal( texture( _BumpMap, UV_PanBM));
}
#line 453
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 457
    surfIN.uv_BumpMap = IN.pack0.zw;
    surfIN.viewDir = IN.viewDir;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 461
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 465
    surf( surfIN, o);
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    mediump vec3 specColor;
    #line 469
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec3 lm = LightingBlinnPhong_DirLightmap( o, lmtex, lmIndTex, normalize(IN.viewDir), true, specColor).xyz;
    c.xyz += specColor;
    #line 473
    c.xyz += (o.Albedo * lm);
    c.w = o.Alpha;
    c.w = o.Alpha;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Vector 15 [unity_4LightPosX0]
Vector 16 [unity_4LightPosY0]
Vector 17 [unity_4LightPosZ0]
Vector 18 [unity_4LightAtten0]
Vector 19 [unity_LightColor0]
Vector 20 [unity_LightColor1]
Vector 21 [unity_LightColor2]
Vector 22 [unity_LightColor3]
Vector 23 [unity_SHAr]
Vector 24 [unity_SHAg]
Vector 25 [unity_SHAb]
Vector 26 [unity_SHBr]
Vector 27 [unity_SHBg]
Vector 28 [unity_SHBb]
Vector 29 [unity_SHC]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 30 [unity_Scale]
Vector 31 [_MainTex_ST]
Vector 32 [_BumpMap_ST]
"3.0-!!ARBvp1.0
# 75 ALU
PARAM c[33] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..32] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[30].w;
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[16];
DP3 R3.w, R3, c[6];
DP3 R4.x, R3, c[5];
DP3 R3.x, R3, c[7];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[15];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MAD R2, R4.x, R0, R2;
MOV R4.w, c[0].x;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[17];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[18];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[20];
MAD R1.xyz, R0.x, c[19], R1;
MAD R0.xyz, R0.z, c[21], R1;
MAD R1.xyz, R0.w, c[22], R0;
MUL R0, R4.xyzz, R4.yzzx;
DP4 R3.z, R0, c[28];
DP4 R3.y, R0, c[27];
DP4 R3.x, R0, c[26];
MUL R1.w, R3, R3;
MAD R0.x, R4, R4, -R1.w;
MOV R0.w, c[0].x;
DP4 R2.z, R4, c[25];
DP4 R2.y, R4, c[24];
DP4 R2.x, R4, c[23];
ADD R2.xyz, R2, R3;
MUL R3.xyz, R0.x, c[29];
ADD R3.xyz, R2, R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
ADD result.texcoord[3].xyz, R3, R1;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R0.xyz, c[13];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[30].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[14];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
DP3 result.texcoord[1].y, R0, R2;
DP3 result.texcoord[2].y, R2, R3;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP3 result.texcoord[2].z, vertex.normal, R3;
DP3 result.texcoord[2].x, vertex.attrib[14], R3;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[32].xyxy, c[32];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[31], c[31].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 75 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_4LightPosX0]
Vector 15 [unity_4LightPosY0]
Vector 16 [unity_4LightPosZ0]
Vector 17 [unity_4LightAtten0]
Vector 18 [unity_LightColor0]
Vector 19 [unity_LightColor1]
Vector 20 [unity_LightColor2]
Vector 21 [unity_LightColor3]
Vector 22 [unity_SHAr]
Vector 23 [unity_SHAg]
Vector 24 [unity_SHAb]
Vector 25 [unity_SHBr]
Vector 26 [unity_SHBg]
Vector 27 [unity_SHBb]
Vector 28 [unity_SHC]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 29 [unity_Scale]
Vector 30 [_MainTex_ST]
Vector 31 [_BumpMap_ST]
"vs_3_0
; 78 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c32, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c29.w
dp4 r0.x, v0, c5
add r1, -r0.x, c15
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c14
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c32.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c16
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c17
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c32.x
dp4 r2.z, r4, c24
dp4 r2.y, r4, c23
dp4 r2.x, r4, c22
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c32.y
mul r0, r0, r1
mul r1.xyz, r0.y, c19
mad r1.xyz, r0.x, c18, r1
mad r0.xyz, r0.z, c20, r1
mad r1.xyz, r0.w, c21, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c27
dp4 r3.y, r0, c26
dp4 r3.x, r0, c25
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c28
add r2.xyz, r2, r3
add r2.xyz, r2, r0
add o4.xyz, r2, r1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c13, r0
mov r0, c9
mov r1.w, c32.x
mov r1.xyz, c12
dp4 r4.y, c13, r0
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c29.w, -v0
mov r1, c8
dp4 r4.x, c13, r1
dp3 o2.y, r2, r3
dp3 o3.y, r3, r4
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o3.z, v2, r4
dp3 o3.x, v1, r4
mad o1.zw, v3.xyxy, c31.xyxy, c31
mad o1.xy, v3, c30, c30.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 176 used size, 12 vars
Vector 144 [_MainTex_ST] 4
Vector 160 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 65 instructions, 6 temp regs, 0 temp arrays:
// ALU 63 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedimbbloegpbloappomlhjppgegkedkfngabaaaaaacaalaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcieajaaaaeaaaabaa
gbacaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacagaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaakaaaaaa
kgiocaaaaaaaaaaaakaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaa
cgbjbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaa
abaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgbpbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaa
adaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaacaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaacaaaaaaaaaaaaaa
egiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
baaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaa
acaaaaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaaihcaabaaa
abaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
abaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaa
egadbaaaabaaaaaabbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaacgaaaaaa
egaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaachaaaaaa
egaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaaciaaaaaa
egaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaa
aaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaa
acaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaa
acaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaa
acaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaa
diaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaak
icaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaiaebaaaaaa
aaaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaacmaaaaaapgapbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
acaaaaaaaaaaaaajpcaabaaaadaaaaaafgafbaiaebaaaaaaacaaaaaaegiocaaa
acaaaaaaadaaaaaadiaaaaahpcaabaaaaeaaaaaafgafbaaaaaaaaaaaegaobaaa
adaaaaaadiaaaaahpcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaa
aaaaaaajpcaabaaaafaaaaaaagaabaiaebaaaaaaacaaaaaaegiocaaaacaaaaaa
acaaaaaaaaaaaaajpcaabaaaacaaaaaakgakbaiaebaaaaaaacaaaaaaegiocaaa
acaaaaaaaeaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaaafaaaaaaagaabaaa
aaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaacaaaaaa
kgakbaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaa
afaaaaaaegaobaaaafaaaaaaegaobaaaadaaaaaadcaaaaajpcaabaaaacaaaaaa
egaobaaaacaaaaaaegaobaaaacaaaaaaegaobaaaadaaaaaaeeaaaaafpcaabaaa
adaaaaaaegaobaaaacaaaaaadcaaaaanpcaabaaaacaaaaaaegaobaaaacaaaaaa
egiocaaaacaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadp
aoaaaaakpcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadp
egaobaaaacaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaa
adaaaaaadeaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaacaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaa
acaaaaaaahaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaagaaaaaa
agaabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaiaaaaaakgakbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaajaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaahhccabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_9 = tmpvar_1.xyz;
  tmpvar_10 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_9.x;
  tmpvar_11[0].y = tmpvar_10.x;
  tmpvar_11[0].z = tmpvar_2.x;
  tmpvar_11[1].x = tmpvar_9.y;
  tmpvar_11[1].y = tmpvar_10.y;
  tmpvar_11[1].z = tmpvar_2.y;
  tmpvar_11[2].x = tmpvar_9.z;
  tmpvar_11[2].y = tmpvar_10.z;
  tmpvar_11[2].z = tmpvar_2.z;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_8;
  mediump vec3 tmpvar_15;
  mediump vec4 normal_16;
  normal_16 = tmpvar_14;
  highp float vC_17;
  mediump vec3 x3_18;
  mediump vec3 x2_19;
  mediump vec3 x1_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAr, normal_16);
  x1_20.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAg, normal_16);
  x1_20.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAb, normal_16);
  x1_20.z = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = (normal_16.xyzz * normal_16.yzzx);
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBr, tmpvar_24);
  x2_19.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBg, tmpvar_24);
  x2_19.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBb, tmpvar_24);
  x2_19.z = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = ((normal_16.x * normal_16.x) - (normal_16.y * normal_16.y));
  vC_17 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (unity_SHC.xyz * vC_17);
  x3_18 = tmpvar_29;
  tmpvar_15 = ((x1_20 + x2_19) + x3_18);
  shlight_3 = tmpvar_15;
  tmpvar_6 = shlight_3;
  highp vec3 tmpvar_30;
  tmpvar_30 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_31;
  tmpvar_31 = (unity_4LightPosX0 - tmpvar_30.x);
  highp vec4 tmpvar_32;
  tmpvar_32 = (unity_4LightPosY0 - tmpvar_30.y);
  highp vec4 tmpvar_33;
  tmpvar_33 = (unity_4LightPosZ0 - tmpvar_30.z);
  highp vec4 tmpvar_34;
  tmpvar_34 = (((tmpvar_31 * tmpvar_31) + (tmpvar_32 * tmpvar_32)) + (tmpvar_33 * tmpvar_33));
  highp vec4 tmpvar_35;
  tmpvar_35 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_31 * tmpvar_8.x) + (tmpvar_32 * tmpvar_8.y)) + (tmpvar_33 * tmpvar_8.z)) * inversesqrt(tmpvar_34))) * (1.0/((1.0 + (tmpvar_34 * unity_4LightAtten0)))));
  highp vec3 tmpvar_36;
  tmpvar_36 = (tmpvar_6 + ((((unity_LightColor[0].xyz * tmpvar_35.x) + (unity_LightColor[1].xyz * tmpvar_35.y)) + (unity_LightColor[2].xyz * tmpvar_35.z)) + (unity_LightColor[3].xyz * tmpvar_35.w)));
  tmpvar_6 = tmpvar_36;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_13).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_3.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_ParallaxMap, tmpvar_3).w;
  h_2 = tmpvar_4;
  highp vec2 tmpvar_5;
  mediump float height_6;
  height_6 = _Parallax;
  mediump vec3 viewDir_7;
  viewDir_7 = xlv_TEXCOORD1;
  highp vec3 v_8;
  mediump float tmpvar_9;
  tmpvar_9 = ((h_2 * height_6) - (height_6 / 2.0));
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(viewDir_7);
  v_8 = tmpvar_10;
  v_8.z = (v_8.z + 0.42);
  tmpvar_5 = (tmpvar_9 * (v_8.xy / v_8.z));
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xy + tmpvar_5);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.zw + tmpvar_5);
  highp vec2 tmpvar_13;
  tmpvar_13.x = ((_RotMT.x - (((tmpvar_11.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_11.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_13.y = ((_RotMT.y - (((tmpvar_11.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_11.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, tmpvar_13);
  lowp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14.xyz * _Color.xyz);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_14.w * _Color.w);
  highp vec2 tmpvar_17;
  tmpvar_17.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_17.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 tmpvar_18;
  tmpvar_18 = ((texture2D (_BumpMap, tmpvar_17).xyz * 2.0) - 1.0);
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize(xlv_TEXCOORD1);
  mediump vec3 viewDir_20;
  viewDir_20 = tmpvar_19;
  lowp vec4 c_21;
  highp float nh_22;
  lowp float tmpvar_23;
  tmpvar_23 = max (0.0, dot (tmpvar_18, xlv_TEXCOORD2));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, dot (tmpvar_18, normalize((xlv_TEXCOORD2 + viewDir_20))));
  nh_22 = tmpvar_24;
  mediump float arg1_25;
  arg1_25 = (_Shininess * 128.0);
  highp float tmpvar_26;
  tmpvar_26 = (pow (nh_22, arg1_25) * tmpvar_14.w);
  highp vec3 tmpvar_27;
  tmpvar_27 = ((((tmpvar_15 * _LightColor0.xyz) * tmpvar_23) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_26)) * 2.0);
  c_21.xyz = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (tmpvar_16 + ((_LightColor0.w * _SpecColor.w) * tmpvar_26));
  c_21.w = tmpvar_28;
  c_1.xyz = (c_21.xyz + (tmpvar_15 * xlv_TEXCOORD3));
  c_1.w = tmpvar_16;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_9 = tmpvar_1.xyz;
  tmpvar_10 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_9.x;
  tmpvar_11[0].y = tmpvar_10.x;
  tmpvar_11[0].z = tmpvar_2.x;
  tmpvar_11[1].x = tmpvar_9.y;
  tmpvar_11[1].y = tmpvar_10.y;
  tmpvar_11[1].z = tmpvar_2.y;
  tmpvar_11[2].x = tmpvar_9.z;
  tmpvar_11[2].y = tmpvar_10.z;
  tmpvar_11[2].z = tmpvar_2.z;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_8;
  mediump vec3 tmpvar_15;
  mediump vec4 normal_16;
  normal_16 = tmpvar_14;
  highp float vC_17;
  mediump vec3 x3_18;
  mediump vec3 x2_19;
  mediump vec3 x1_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAr, normal_16);
  x1_20.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAg, normal_16);
  x1_20.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAb, normal_16);
  x1_20.z = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = (normal_16.xyzz * normal_16.yzzx);
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBr, tmpvar_24);
  x2_19.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBg, tmpvar_24);
  x2_19.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBb, tmpvar_24);
  x2_19.z = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = ((normal_16.x * normal_16.x) - (normal_16.y * normal_16.y));
  vC_17 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (unity_SHC.xyz * vC_17);
  x3_18 = tmpvar_29;
  tmpvar_15 = ((x1_20 + x2_19) + x3_18);
  shlight_3 = tmpvar_15;
  tmpvar_6 = shlight_3;
  highp vec3 tmpvar_30;
  tmpvar_30 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_31;
  tmpvar_31 = (unity_4LightPosX0 - tmpvar_30.x);
  highp vec4 tmpvar_32;
  tmpvar_32 = (unity_4LightPosY0 - tmpvar_30.y);
  highp vec4 tmpvar_33;
  tmpvar_33 = (unity_4LightPosZ0 - tmpvar_30.z);
  highp vec4 tmpvar_34;
  tmpvar_34 = (((tmpvar_31 * tmpvar_31) + (tmpvar_32 * tmpvar_32)) + (tmpvar_33 * tmpvar_33));
  highp vec4 tmpvar_35;
  tmpvar_35 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_31 * tmpvar_8.x) + (tmpvar_32 * tmpvar_8.y)) + (tmpvar_33 * tmpvar_8.z)) * inversesqrt(tmpvar_34))) * (1.0/((1.0 + (tmpvar_34 * unity_4LightAtten0)))));
  highp vec3 tmpvar_36;
  tmpvar_36 = (tmpvar_6 + ((((unity_LightColor[0].xyz * tmpvar_35.x) + (unity_LightColor[1].xyz * tmpvar_35.y)) + (unity_LightColor[2].xyz * tmpvar_35.z)) + (unity_LightColor[3].xyz * tmpvar_35.w)));
  tmpvar_6 = tmpvar_36;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_13).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_3.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_ParallaxMap, tmpvar_3).w;
  h_2 = tmpvar_4;
  highp vec2 tmpvar_5;
  mediump float height_6;
  height_6 = _Parallax;
  mediump vec3 viewDir_7;
  viewDir_7 = xlv_TEXCOORD1;
  highp vec3 v_8;
  mediump float tmpvar_9;
  tmpvar_9 = ((h_2 * height_6) - (height_6 / 2.0));
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(viewDir_7);
  v_8 = tmpvar_10;
  v_8.z = (v_8.z + 0.42);
  tmpvar_5 = (tmpvar_9 * (v_8.xy / v_8.z));
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xy + tmpvar_5);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.zw + tmpvar_5);
  highp vec2 tmpvar_13;
  tmpvar_13.x = ((_RotMT.x - (((tmpvar_11.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_11.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_13.y = ((_RotMT.y - (((tmpvar_11.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_11.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, tmpvar_13);
  lowp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14.xyz * _Color.xyz);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_14.w * _Color.w);
  highp vec2 tmpvar_17;
  tmpvar_17.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_17.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 normal_18;
  normal_18.xy = ((texture2D (_BumpMap, tmpvar_17).wy * 2.0) - 1.0);
  normal_18.z = sqrt((1.0 - clamp (dot (normal_18.xy, normal_18.xy), 0.0, 1.0)));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize(xlv_TEXCOORD1);
  mediump vec3 viewDir_20;
  viewDir_20 = tmpvar_19;
  lowp vec4 c_21;
  highp float nh_22;
  lowp float tmpvar_23;
  tmpvar_23 = max (0.0, dot (normal_18, xlv_TEXCOORD2));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, dot (normal_18, normalize((xlv_TEXCOORD2 + viewDir_20))));
  nh_22 = tmpvar_24;
  mediump float arg1_25;
  arg1_25 = (_Shininess * 128.0);
  highp float tmpvar_26;
  tmpvar_26 = (pow (nh_22, arg1_25) * tmpvar_14.w);
  highp vec3 tmpvar_27;
  tmpvar_27 = ((((tmpvar_15 * _LightColor0.xyz) * tmpvar_23) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_26)) * 2.0);
  c_21.xyz = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (tmpvar_16 + ((_LightColor0.w * _SpecColor.w) * tmpvar_26));
  c_21.w = tmpvar_28;
  c_1.xyz = (c_21.xyz + (tmpvar_15 * xlv_TEXCOORD3));
  c_1.w = tmpvar_16;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    lowp vec3 lightDir;
    lowp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
#line 393
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
#line 397
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 408
#line 433
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
#line 82
highp vec3 ObjSpaceLightDir( in highp vec4 v ) {
    highp vec3 objSpaceLightPos = (_World2Object * _WorldSpaceLightPos0).xyz;
    return objSpaceLightPos.xyz;
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 435
v2f_surf vert_surf( in appdata_full v ) {
    #line 437
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
    #line 441
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 binormal = (cross( v.normal, v.tangent.xyz) * v.tangent.w);
    highp mat3 rotation = xll_transpose_mf3x3(mat3( v.tangent.xyz, binormal, v.normal));
    highp vec3 lightDir = (rotation * ObjSpaceLightDir( v.vertex));
    #line 445
    o.lightDir = lightDir;
    highp vec3 viewDirForLight = (rotation * ObjSpaceViewDir( v.vertex));
    o.viewDir = viewDirForLight;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    #line 449
    o.vlight = shlight;
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    #line 453
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    lowp vec3 lightDir;
    lowp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
#line 393
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
#line 397
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 408
#line 433
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 166
highp vec2 ParallaxOffset( in mediump float h, in mediump float height, in mediump vec3 viewDir ) {
    h = ((h * height) - (height / 2.0));
    highp vec3 v = normalize(viewDir);
    #line 170
    v.z += 0.42;
    return (h * (v.xy / v.z));
}
#line 272
lowp vec3 UnpackNormal( in lowp vec4 packednormal ) {
    #line 274
    return ((packednormal.xyz * 2.0) - 1.0);
}
#line 408
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanPM = vec2( ((_RotPM.x - (((IN.uv_BumpMap.x - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y)), ((_RotPM.y - (((IN.uv_BumpMap.x - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y)));
    mediump float h = texture( _ParallaxMap, UV_PanPM).w;
    #line 412
    highp vec2 offset = ParallaxOffset( h, _Parallax, IN.viewDir);
    IN.uv_MainTex += offset;
    IN.uv_BumpMap += offset;
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    #line 416
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    o.Albedo = (tex.xyz * _Color.xyz);
    o.Gloss = tex.w;
    o.Alpha = (tex.w * _Color.w);
    #line 420
    o.Specular = _Shininess;
    highp vec2 UV_PanBM = vec2( ((_RotMT.x - (((IN.uv_BumpMap.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_BumpMap.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    o.Normal = UnpackNormal( texture( _BumpMap, UV_PanBM));
}
#line 455
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 457
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_BumpMap = IN.pack0.zw;
    surfIN.viewDir = IN.viewDir;
    #line 461
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 465
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp float atten = 1.0;
    #line 469
    lowp vec4 c = vec4( 0.0);
    c = LightingBlinnPhong( o, IN.lightDir, normalize(IN.viewDir), atten);
    c.xyz += (o.Albedo * IN.vlight);
    c.w = o.Alpha;
    #line 473
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 3
//   opengl - ALU: 51 to 96, TEX: 3 to 5
//   d3d9 - ALU: 71 to 118, TEX: 3 to 5
//   d3d11 - ALU: 34 to 63, TEX: 3 to 5, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_PanPM]
Vector 6 [_RotPM]
Vector 7 [_Color]
Float 8 [_Shininess]
Float 9 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
"3.0-!!ARBfp1.0
# 86 ALU, 3 TEX
PARAM c[12] = { program.local[0..9],
		{ 0.0055555557, 1, 3.1415927, 0.5 },
		{ 0.41999999, 2, 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.x, c[6].w;
MAD R0.x, R0, c[10], c[10].y;
MOV R1.w, c[0].y;
MUL R0.x, R0, c[10].z;
MAD R0.x, R1.w, c[6].z, R0;
COS R0.w, R0.x;
SIN R0.z, R0.x;
ADD R0.x, fragment.texcoord[0].w, -c[6].y;
MUL R0.y, R0.x, R0.z;
ADD R1.x, fragment.texcoord[0].z, -c[6];
MAD R0.y, R1.x, R0.w, -R0;
MUL R0.x, R0.w, R0;
MAD R0.x, R1, R0.z, R0;
ADD R0.x, -R0, c[6].y;
MAD R0.w, R1, c[5].y, R0.x;
ADD R0.y, -R0, c[6].x;
MAD R0.z, R1.w, c[5].x, R0.y;
TEX R0.w, R0.zwzw, texture[0], 2D;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.z, R0.x;
MOV R0.y, c[9].x;
MUL R0.x, R0.y, c[10].w;
MUL R2.xyz, R0.z, fragment.texcoord[1];
MAD R1.z, R0.w, c[9].x, -R0.x;
ADD R0.y, R2.z, c[11].x;
RCP R0.y, R0.y;
MOV R0.x, c[4].w;
MAD R0.x, R0, c[10], c[10].y;
MUL R1.xy, R2, R0.y;
MUL R0.w, R0.x, c[10].z;
MAD R0.xy, R1.z, R1, fragment.texcoord[0].zwzw;
MAD R2.y, R1.w, c[4].z, R0.w;
MAD R1.xy, R1.z, R1, fragment.texcoord[0];
COS R2.w, R2.y;
ADD R2.x, R0.y, -c[4].y;
SIN R0.w, R2.y;
MUL R0.y, R2.w, R2.x;
MUL R2.x, R0.w, R2;
ADD R0.x, R0, -c[4];
MAD R2.x, R2.w, R0, -R2;
MAD R0.x, R0.w, R0, R0.y;
ADD R0.y, -R0.x, c[4];
ADD R2.x, -R2, c[4];
MAD R0.x, R1.w, c[3], R2;
MAD R0.y, R1.w, c[3], R0;
TEX R3.yw, R0, texture[2], 2D;
MOV R2.x, c[10].y;
MAD R0.xy, R3.wyzw, c[11].y, -R2.x;
MUL R3.xy, R0, R0;
MOV R2.xyz, fragment.texcoord[2];
MAD R2.xyz, R0.z, fragment.texcoord[1], R2;
DP3 R0.z, R2, R2;
RSQ R0.z, R0.z;
ADD_SAT R3.x, R3, R3.y;
ADD R3.x, -R3, c[10].y;
MUL R2.xyz, R0.z, R2;
RSQ R3.x, R3.x;
RCP R0.z, R3.x;
DP3 R2.x, R0, R2;
MOV R2.y, c[11].w;
MUL R1.z, R2.y, c[8].x;
MAX R2.x, R2, c[11].z;
POW R2.x, R2.x, R1.z;
ADD R1.y, R1, -c[4];
MUL R1.z, R1.y, R0.w;
MUL R1.y, R2.w, R1;
ADD R1.x, R1, -c[4];
MAD R0.w, R1.x, R0, R1.y;
MAD R1.x, R1, R2.w, -R1.z;
ADD R0.w, -R0, c[4].y;
ADD R1.x, -R1, c[4];
MAD R1.y, R1.w, c[3], R0.w;
MAD R1.x, R1.w, c[3], R1;
TEX R1, R1, texture[1], 2D;
MUL R2.w, R1, R2.x;
DP3 R2.x, R0, fragment.texcoord[2];
MUL R0, R1, c[7];
MAX R1.w, R2.x, c[11].z;
MUL R2.xyz, R0, c[1];
MOV R1.xyz, c[2];
MUL R2.xyz, R2, R1.w;
MUL R1.xyz, R1, c[1];
MAD R1.xyz, R1, R2.w, R2;
MUL R1.xyz, R1, c[11].y;
MAD result.color.xyz, R0, fragment.texcoord[3], R1;
MOV result.color.w, R0;
END
# 86 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_PanPM]
Vector 6 [_RotPM]
Vector 7 [_Color]
Float 8 [_Shininess]
Float 9 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
"ps_3_0
; 110 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c10, 0.00555556, 1.00000000, 3.14159274, 0.50000000
def c11, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c12, 0.41999999, 2.00000000, -1.00000000, 0.00000000
def c13, 128.00000000, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
mov r0.x, c6.w
mad r0.x, r0, c10, c10.y
mov r0.y, c6.z
mul r0.x, r0, c10.z
mad r0.x, c0.y, r0.y, r0
mad r0.x, r0, c11, c11.y
frc r0.x, r0
mad r1.x, r0, c11.z, c11.w
sincos r0.xy, r1.x
add r0.w, v0, -c6.y
mul r0.z, r0.w, r0.x
mul r0.w, r0, r0.y
add r1.x, v0.z, -c6
mad r0.x, r1, r0, -r0.w
mad r0.y, r1.x, r0, r0.z
mov r0.z, c5.x
add r0.x, -r0, c6
mad r0.x, c0.y, r0.z, r0
mov_pp r0.z, c10.w
mov r0.w, c5.y
add r0.y, -r0, c6
mad r0.y, c0, r0.w, r0
texld r0.w, r0, s0
mul_pp r0.z, c9.x, r0
dp3_pp r0.y, v1, v1
mad_pp r1.w, r0, c9.x, -r0.z
mov r0.x, c4.w
mad r0.w, r0.x, c10.x, c10.y
rsq_pp r1.z, r0.y
mul_pp r0.xyz, r1.z, v1
mov r1.x, c4.z
mul r0.w, r0, c10.z
mad r0.w, c0.y, r1.x, r0
add r1.x, r0.z, c12
mad r0.z, r0.w, c11.x, c11.y
rcp r0.w, r1.x
mul r2.xy, r0, r0.w
mad r1.xy, r1.w, r2, v0.zwzw
frc r0.z, r0
mad r2.z, r0, c11, c11.w
sincos r0.xy, r2.z
add r0.z, r1.y, -c4.y
mul r0.w, r0.y, r0.z
add r1.x, r1, -c4
mul r0.z, r0.x, r0
mad r0.z, r0.y, r1.x, r0
mad r0.w, r0.x, r1.x, -r0
add r0.z, -r0, c4.y
mov r1.x, c3.y
mad r1.y, c0, r1.x, r0.z
add r0.z, -r0.w, c4.x
mov r0.w, c3.x
mad r1.x, c0.y, r0.w, r0.z
texld r3.yw, r1, s2
mad_pp r1.xy, r3.wyzw, c12.y, c12.z
mul_pp r0.zw, r1.xyxy, r1.xyxy
add_pp_sat r0.z, r0, r0.w
add_pp r0.w, -r0.z, c10.y
mov_pp r3.xyz, v2
mad_pp r3.xyz, r1.z, v1, r3
dp3_pp r0.z, r3, r3
rsq_pp r0.w, r0.w
rsq_pp r0.z, r0.z
mul_pp r3.xyz, r0.z, r3
rcp_pp r1.z, r0.w
dp3_pp r0.w, r1, r3
dp3_pp r1.x, r1, v2
max_pp r2.w, r1.x, c12
mov_pp r0.z, c8.x
mov_pp r1.xyz, c1
mul_pp r0.z, c13.x, r0
max_pp r0.w, r0, c12
pow r3, r0.w, r0.z
mad r0.zw, r1.w, r2.xyxy, v0.xyxy
add r0.w, r0, -c4.y
mul r2.x, r0.w, r0.y
mul r0.w, r0, r0.x
add r0.z, r0, -c4.x
mad r0.y, r0.z, r0, r0.w
mad r0.z, r0, r0.x, -r2.x
add r0.x, -r0.y, c4.y
mov r0.y, c3
mad r0.y, c0, r0, r0.x
add r0.x, -r0.z, c4
mov r0.z, c3.x
mad r0.x, c0.y, r0.z, r0
texld r0, r0, s1
mov r1.w, r3.x
mul r1.w, r0, r1
mul_pp r0, r0, c7
mul_pp r2.xyz, r0, c1
mul_pp r2.xyz, r2, r2.w
mul_pp r1.xyz, c2, r1
mad r1.xyz, r1, r1.w, r2
mul r1.xyz, r1, c12.y
mad_pp oC0.xyz, r0, v3, r1
mov_pp oC0.w, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
ConstBuffer "$Globals" 176 // 136 used size, 12 vars
Vector 16 [_LightColor0] 4
Vector 32 [_SpecColor] 4
Vector 48 [_PanMT] 4
Vector 64 [_RotMT] 4
Vector 80 [_PanPM] 4
Vector 96 [_RotPM] 4
Vector 112 [_Color] 4
Float 128 [_Shininess]
Float 132 [_Parallax]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_ParallaxMap] 2D 2
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_BumpMap] 2D 1
// 59 instructions, 5 temp regs, 0 temp arrays:
// ALU 53 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedllnafgcnjdlgdiagflnjfolgopmjjiceabaaaaaagiajaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcgaaiaaaaeaaaaaaabiacaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacafaaaaaadcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaagaaaaaa
abeaaaaagballgdlabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaanlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaa
agaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaa
aaaaaaaabcaabaaaabaaaaaaakaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaa
pgbobaaaabaaaaaafgiecaiaebaaaaaaaaaaaaaaagaaaaaadiaaaaahjcaabaaa
aaaaaaaaagaabaaaaaaaaaaafgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaa
ckaabaaaaaaaaaaaakaabaaaabaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaaj
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaa
aaaaaaajdcaabaaaaaaaaaaaegaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaa
agaaaaaadcaaaaalccaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaabkiacaaa
abaaaaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaa
aaaaaaaaafaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaa
diaaaaaldcaabaaaaaaaaaaabgifcaaaaaaaaaaaaiaaaaaaaceaaaaaaaaaaadp
aaaaaaedaaaaaaaaaaaaaaaadcaaaaalbcaabaaaaaaaaaaadkaabaaaaaaaaaaa
bkiacaaaaaaaaaaaaiaaaaaaakaabaiaebaaaaaaaaaaaaaabaaaaaahecaabaaa
aaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaafecaabaaaaaaaaaaa
ckaabaaaaaaaaaaadiaaaaahdcaabaaaabaaaaaakgakbaaaaaaaaaaaegbabaaa
acaaaaaadcaaaaajicaabaaaaaaaaaaackbabaaaacaaaaaackaabaaaaaaaaaaa
abeaaaaadnaknhdodcaaaaajhcaabaaaacaaaaaaegbcbaaaacaaaaaakgakbaaa
aaaaaaaaegbcbaaaadaaaaaaaoaaaaahpcaabaaaabaaaaaabgabbaaaabaaaaaa
pgapbaaaaaaaaaaadcaaaaajpcaabaaaabaaaaaaagaabaaaaaaaaaaaegaobaaa
abaaaaaabgblbaaaabaaaaaaaaaaaaajpcaabaaaabaaaaaaegaobaaaabaaaaaa
bgibcaiaebaaaaaaaaaaaaaaaeaaaaaadcaaaaakbcaabaaaaaaaaaaadkiacaaa
aaaaaaaaaeaaaaaaabeaaaaagballgdlabeaaaaaaaaaiadpdiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaanlapejeadcaaaaalbcaabaaaaaaaaaaa
ckiacaaaaaaaaaaaaeaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaa
enaaaaahbcaabaaaaaaaaaaabcaabaaaadaaaaaaakaabaaaaaaaaaaadiaaaaah
pcaabaaaaeaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakfcaabaaa
aaaaaaaafgahbaaaabaaaaaaagaabaaaadaaaaaaagacbaiaebaaaaaaaeaaaaaa
dcaaaaajdcaabaaaabaaaaaaigaabaaaabaaaaaaagaabaaaadaaaaaangafbaaa
aeaaaaaaaaaaaaajdcaabaaaabaaaaaaegaabaiaebaaaaaaabaaaaaafgifcaaa
aaaaaaaaaeaaaaaadcaaaaalmcaabaaaabaaaaaafgifcaaaaaaaaaaaadaaaaaa
fgifcaaaabaaaaaaaaaaaaaaagaebaaaabaaaaaaaaaaaaajfcaabaaaaaaaaaaa
agacbaiaebaaaaaaaaaaaaaaagiacaaaaaaaaaaaaeaaaaaadcaaaaaldcaabaaa
abaaaaaaagiacaaaaaaaaaaaadaaaaaafgifcaaaabaaaaaaaaaaaaaaigaabaaa
aaaaaaaaefaaaaajpcaabaaaadaaaaaangafbaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaigaabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaaaaaaaaadcaaaaapdcaabaaaadaaaaaahgapbaaaadaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaaaaaaaaaaaaaapaaaaahbcaabaaaaaaaaaaaegaabaaaadaaaaaaegaabaaa
adaaaaaaddaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiadp
aaaaaaaibcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
elaaaaafecaabaaaadaaaaaaakaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaa
egacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaahncaabaaaaaaaaaaaagaabaaaaaaaaaaaagajbaaaacaaaaaa
baaaaaahbcaabaaaaaaaaaaaegacbaaaadaaaaaaigadbaaaaaaaaaaabaaaaaah
ecaabaaaaaaaaaaaegacbaaaadaaaaaaegbcbaaaadaaaaaadeaaaaakfcaabaaa
aaaaaaaaagacbaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
cpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaahbcaabaaaaaaaaaaadkaabaaaabaaaaaaakaabaaaaaaaaaaa
diaaaaajhcaabaaaacaaaaaaegiccaaaaaaaaaaaabaaaaaaegiccaaaaaaaaaaa
acaaaaaadiaaaaahlcaabaaaaaaaaaaaagaabaaaaaaaaaaaegaibaaaacaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
diaaaaaiiccabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaaaaaaaaaaahaaaaaa
diaaaaaihcaabaaaacaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaacaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaaegbcbaaaaeaaaaaaegacbaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_Time]
Vector 1 [_PanMT]
Vector 2 [_RotMT]
Vector 3 [_PanPM]
Vector 4 [_RotPM]
Vector 5 [_Color]
Float 6 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [unity_Lightmap] 2D
"3.0-!!ARBfp1.0
# 51 ALU, 3 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0055555557, 1, 3.1415927, 0.5 },
		{ 0.41999999, 8 } };
TEMP R0;
TEMP R1;
MOV R0.x, c[4].w;
MAD R0.x, R0, c[7], c[7].y;
MOV R1.x, c[0].y;
MUL R0.x, R0, c[7].z;
MAD R0.y, R1.x, c[4].z, R0.x;
COS R0.x, R0.y;
SIN R0.z, R0.y;
ADD R0.y, fragment.texcoord[0].w, -c[4];
MUL R0.w, R0.y, R0.z;
MUL R1.y, R0.x, R0;
ADD R0.y, fragment.texcoord[0].z, -c[4].x;
MAD R0.x, R0.y, R0, -R0.w;
MAD R0.z, R0.y, R0, R1.y;
ADD R0.y, -R0.z, c[4];
ADD R0.x, -R0, c[4];
MAD R0.y, R1.x, c[3], R0;
MAD R0.x, R1, c[3], R0;
TEX R0.w, R0, texture[0], 2D;
MOV R0.x, c[6];
MUL R1.y, R0.x, c[7].w;
MAD R0.w, R0, c[6].x, -R1.y;
DP3 R0.y, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.y, R0.y;
MUL R0.xyz, R0.y, fragment.texcoord[1];
ADD R0.z, R0, c[8].x;
RCP R0.z, R0.z;
MUL R0.xy, R0, R0.z;
MAD R0.xy, R0.w, R0, fragment.texcoord[0];
MOV R1.y, c[2].w;
MAD R1.y, R1, c[7].x, c[7];
MUL R0.z, R1.y, c[7];
MAD R0.z, R1.x, c[2], R0;
ADD R1.y, R0, -c[2];
SIN R0.y, R0.z;
MUL R0.w, R1.y, R0.y;
COS R0.z, R0.z;
MUL R1.y, R0.z, R1;
ADD R0.x, R0, -c[2];
MAD R0.y, R0.x, R0, R1;
MAD R0.x, R0, R0.z, -R0.w;
ADD R0.y, -R0, c[2];
ADD R0.x, -R0, c[2];
MAD R0.y, R1.x, c[1], R0;
MAD R0.x, R1, c[1], R0;
TEX R0, R0, texture[1], 2D;
MUL R0, R0, c[5];
TEX R1, fragment.texcoord[2], texture[3], 2D;
MUL R1.xyz, R1.w, R1;
MUL R0.xyz, R1, R0;
MOV result.color.w, R0;
MUL result.color.xyz, R0, c[8].y;
END
# 51 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_Time]
Vector 1 [_PanMT]
Vector 2 [_RotMT]
Vector 3 [_PanPM]
Vector 4 [_RotPM]
Vector 5 [_Color]
Float 6 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [unity_Lightmap] 2D
"ps_3_0
; 71 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
def c7, 0.00555556, 1.00000000, 3.14159274, 0.50000000
def c8, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c9, 0.41999999, 8.00000000, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
mov r0.x, c4.w
mad r0.x, r0, c7, c7.y
mul r0.y, r0.x, c7.z
mov r0.x, c4.z
mad r0.x, c0.y, r0, r0.y
mad r0.x, r0, c8, c8.y
frc r0.x, r0
mad r1.x, r0, c8.z, c8.w
sincos r0.xy, r1.x
add r0.z, v0.w, -c4.y
mul r1.x, r0.z, r0
mul r0.w, r0.z, r0.y
add r0.z, v0, -c4.x
mad r0.x, r0.z, r0, -r0.w
mad r0.z, r0, r0.y, r1.x
add r0.y, -r0.x, c4.x
add r0.w, -r0.z, c4.y
mov r0.x, c3
mad r0.x, c0.y, r0, r0.y
mov_pp r0.z, c7.w
mov r0.y, c3
mad r0.y, c0, r0, r0.w
texld r0.w, r0, s0
mul_pp r0.z, c6.x, r0
mov r0.y, c2.w
dp3_pp r0.x, v1, v1
mad_pp r1.z, r0.w, c6.x, -r0
mad r0.y, r0, c7.x, c7
mul r0.z, r0.y, c7
mov r0.y, c2.z
mad r0.w, c0.y, r0.y, r0.z
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v1
mad r0.w, r0, c8.x, c8.y
frc r0.w, r0
add r0.z, r0, c9.x
rcp r0.z, r0.z
mul r1.xy, r0, r0.z
mad r1.w, r0, c8.z, c8
sincos r0.xy, r1.w
mad r0.zw, r1.z, r1.xyxy, v0.xyxy
add r0.w, r0, -c2.y
mul r1.x, r0.w, r0.y
mul r0.w, r0, r0.x
add r0.z, r0, -c2.x
mad r0.y, r0.z, r0, r0.w
mad r0.z, r0, r0.x, -r1.x
texld r1, v2, s3
mov r0.x, c1.y
add r0.y, -r0, c2
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c2.x
mov r0.x, c1
mad r0.x, c0.y, r0, r0.z
texld r0, r0, s1
mul_pp r0, r0, c5
mul_pp r1.xyz, r1.w, r1
mul_pp r0.xyz, r1, r0
mov_pp oC0.w, r0
mul_pp oC0.xyz, r0, c9.y
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
ConstBuffer "$Globals" 192 // 136 used size, 13 vars
Vector 48 [_PanMT] 4
Vector 64 [_RotMT] 4
Vector 80 [_PanPM] 4
Vector 96 [_RotPM] 4
Vector 112 [_Color] 4
Float 132 [_Parallax]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_ParallaxMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [unity_Lightmap] 2D 2
// 40 instructions, 3 temp regs, 0 temp arrays:
// ALU 34 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedenagjeggglkopmigedhcdfjhpcnlcmffabaaaaaapaagaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcaaagaaaaeaaaaaaaiaabaaaafjaaaaaeegiocaaa
aaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaaddcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaadcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaagaaaaaaabeaaaaa
gballgdlabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaanlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaagaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaa
bcaabaaaabaaaaaaakaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaa
abaaaaaafgiecaiaebaaaaaaaaaaaaaaagaaaaaadiaaaaahjcaabaaaaaaaaaaa
agaabaaaaaaaaaaafgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaa
aaaaaaaaakaabaaaabaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaaj
dcaabaaaaaaaaaaaegaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaagaaaaaa
dcaaaaalccaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaabkiacaaaabaaaaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaa
afaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaa
aaaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaai
bcaabaaaaaaaaaaabkiacaaaaaaaaaaaaiaaaaaaabeaaaaaaaaaaadpdcaaaaal
bcaabaaaaaaaaaaadkaabaaaaaaaaaaabkiacaaaaaaaaaaaaiaaaaaaakaabaia
ebaaaaaaaaaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaahmcaabaaa
aaaaaaaafgafbaaaaaaaaaaaagbebaaaacaaaaaadcaaaaajccaabaaaaaaaaaaa
ckbabaaaacaaaaaabkaabaaaaaaaaaaaabeaaaaadnaknhdoaoaaaaahgcaabaaa
aaaaaaaapgaobaaaaaaaaaaafgafbaaaaaaaaaaadcaaaaajdcaabaaaaaaaaaaa
agaabaaaaaaaaaaajgafbaaaaaaaaaaabgbfbaaaabaaaaaaaaaaaaajdcaabaaa
aaaaaaaaegaabaaaaaaaaaaabgifcaiaebaaaaaaaaaaaaaaaeaaaaaadcaaaaak
ecaabaaaaaaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaagballgdlabeaaaaa
aaaaiadpdiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaanlapejea
dcaaaaalecaabaaaaaaaaaaackiacaaaaaaaaaaaaeaaaaaabkiacaaaabaaaaaa
aaaaaaaackaabaaaaaaaaaaaenaaaaahbcaabaaaabaaaaaabcaabaaaacaaaaaa
ckaabaaaaaaaaaaadiaaaaahmcaabaaaaaaaaaaaagaebaaaaaaaaaaaagaabaaa
abaaaaaadcaaaaakccaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaacaaaaaa
ckaabaiaebaaaaaaaaaaaaaadcaaaaajbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaacaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaabkiacaaaaaaaaaaaaeaaaaaadcaaaaalccaabaaaabaaaaaa
bkiacaaaaaaaaaaaadaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaa
aaaaaaajbcaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaadaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaaiiccabaaaaaaaaaaa
dkaabaaaaaaaaaaadkiacaaaaaaaaaaaahaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaadaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaapgapbaaaaaaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanPM]
Vector 5 [_RotPM]
Vector 6 [_Color]
Float 7 [_Shininess]
Float 8 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"3.0-!!ARBfp1.0
# 96 ALU, 5 TEX
PARAM c[14] = { program.local[0..8],
		{ 0.0055555557, 1, 3.1415927, 0.5 },
		{ 0.41999999, 2, 8, 0 },
		{ -0.40824828, -0.70710677, 0.57735026, 128 },
		{ -0.40824831, 0.70710677, 0.57735026 },
		{ 0.81649655, 0, 0.57735026 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
MUL R2.xyz, R0, c[10].z;
MOV R0.x, c[5].w;
MAD R0.w, R0.x, c[9].x, c[9].y;
MUL R1.xyz, R2.y, c[12];
MAD R0.xyz, R2.x, c[13], R1;
MAD R1.xyz, R2.z, c[11], R0;
MOV R1.w, c[0].y;
MUL R0.w, R0, c[9].z;
MAD R0.w, R1, c[5].z, R0;
COS R0.y, R0.w;
ADD R0.x, fragment.texcoord[0].w, -c[5].y;
SIN R0.z, R0.w;
MUL R0.w, R0.x, R0.z;
MUL R2.w, R0.y, R0.x;
ADD R0.x, fragment.texcoord[0].z, -c[5];
MAD R0.z, R0.x, R0, R2.w;
MAD R0.x, R0, R0.y, -R0.w;
ADD R0.y, -R0.z, c[5];
ADD R0.x, -R0, c[5];
MAD R0.y, R1.w, c[4], R0;
MAD R0.x, R1.w, c[4], R0;
TEX R0.w, R0, texture[0], 2D;
DP3 R0.y, fragment.texcoord[1], fragment.texcoord[1];
MOV R0.x, c[8];
MUL R2.w, R0.x, c[9];
RSQ R4.x, R0.y;
MUL R0.xyz, R4.x, fragment.texcoord[1];
MAD R2.w, R0, c[8].x, -R2;
ADD R0.z, R0, c[10].x;
RCP R0.z, R0.z;
MUL R3.xy, R0, R0.z;
MAD R0.xy, R2.w, R3, fragment.texcoord[0].zwzw;
MOV R0.w, c[3];
MAD R0.w, R0, c[9].x, c[9].y;
MUL R0.z, R0.w, c[9];
MAD R0.z, R1.w, c[3], R0;
COS R3.z, R0.z;
SIN R3.w, R0.z;
ADD R0.y, R0, -c[3];
MUL R0.z, R3.w, R0.y;
ADD R0.x, R0, -c[3];
MUL R0.y, R3.z, R0;
MAD R0.y, R3.w, R0.x, R0;
MAD R0.x, R3.z, R0, -R0.z;
DP3 R0.z, R1, R1;
RSQ R0.z, R0.z;
MUL R1.xyz, R0.z, R1;
ADD R0.y, -R0, c[3];
ADD R0.x, -R0, c[3];
MAD R1.xyz, R4.x, fragment.texcoord[1], R1;
MAD R0.x, R1.w, c[2], R0;
MAD R0.y, R1.w, c[2], R0;
TEX R0.yw, R0, texture[2], 2D;
MOV R0.x, c[9].y;
MAD R0.xy, R0.wyzw, c[10].y, -R0.x;
MUL R0.zw, R0.xyxy, R0.xyxy;
ADD_SAT R0.z, R0, R0.w;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R1;
ADD R0.z, -R0, c[9].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R1.x, R0, R1;
MOV R0.w, c[11];
MUL R1.y, R0.w, c[7].x;
MAX R0.w, R1.x, c[10];
POW R4.x, R0.w, R1.y;
DP3_SAT R1.z, R0, c[11];
DP3_SAT R1.y, R0, c[12];
DP3_SAT R1.x, R0, c[13];
DP3 R1.x, R1, R2;
TEX R0, fragment.texcoord[2], texture[3], 2D;
MUL R0.xyz, R0.w, R0;
MAD R2.xy, R2.w, R3, fragment.texcoord[0];
ADD R0.w, R2.y, -c[3].y;
MUL R0.xyz, R0, R1.x;
MUL R0.xyz, R0, c[10].z;
MUL R2.y, R0.w, R3.w;
MUL R2.z, R3, R0.w;
ADD R0.w, R2.x, -c[3].x;
MAD R2.x, R0.w, R3.w, R2.z;
MAD R0.w, R0, R3.z, -R2.y;
ADD R2.x, -R2, c[3].y;
MAD R2.y, R1.w, c[2], R2.x;
ADD R0.w, -R0, c[3].x;
MAD R2.x, R1.w, c[2], R0.w;
TEX R2, R2, texture[1], 2D;
MUL R1.xyz, R0, c[1];
MUL R1.xyz, R2.w, R1;
MUL R2, R2, c[6];
MUL R1.xyz, R1, R4.x;
MAD result.color.xyz, R2, R0, R1;
MOV result.color.w, R2;
END
# 96 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanPM]
Vector 5 [_RotPM]
Vector 6 [_Color]
Float 7 [_Shininess]
Float 8 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"ps_3_0
; 118 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c9, 0.00555556, 1.00000000, 3.14159274, 0.50000000
def c10, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c11, 0.41999999, 2.00000000, -1.00000000, 8.00000000
def c12, -0.40824828, -0.70710677, 0.57735026, 0.00000000
def c13, -0.40824831, 0.70710677, 0.57735026, 128.00000000
def c14, 0.81649655, 0.00000000, 0.57735026, 0
dcl_texcoord0 v0
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
mov r0.x, c5.w
mad r0.x, r0, c9, c9.y
mov r0.y, c5.z
mul r0.x, r0, c9.z
mad r0.x, c0.y, r0.y, r0
mad r0.x, r0, c10, c10.y
frc r0.x, r0
mad r1.x, r0, c10.z, c10.w
sincos r0.xy, r1.x
add r0.w, v0, -c5.y
mul r0.z, r0.w, r0.x
mul r0.w, r0, r0.y
add r1.x, v0.z, -c5
mad r0.x, r1, r0, -r0.w
mad r0.y, r1.x, r0, r0.z
mov r0.z, c4.x
add r0.x, -r0, c5
mad r0.x, c0.y, r0.z, r0
mov_pp r0.z, c9.w
mov r0.w, c4.y
add r0.y, -r0, c5
mad r0.y, c0, r0.w, r0
texld r0.w, r0, s0
mul_pp r0.z, c8.x, r0
dp3_pp r0.y, v1, v1
mad_pp r1.z, r0.w, c8.x, -r0
mov r0.x, c3.w
mad r0.w, r0.x, c9.x, c9.y
rsq_pp r1.w, r0.y
mul_pp r0.xyz, r1.w, v1
mov r1.x, c3.z
mul r0.w, r0, c9.z
mad r0.w, c0.y, r1.x, r0
add r1.x, r0.z, c11
mad r0.z, r0.w, c10.x, c10.y
rcp r0.w, r1.x
mul r1.xy, r0, r0.w
frc r0.z, r0
mad r2.z, r0, c10, c10.w
mad r2.xy, r1.z, r1, v0.zwzw
sincos r0.xy, r2.z
add r0.w, r2.y, -c3.y
mul r2.y, r0, r0.w
add r0.z, r2.x, -c3.x
mad r2.x, r0, r0.z, -r2.y
mul r0.w, r0.x, r0
mad r0.z, r0.y, r0, r0.w
add r3.x, -r2, c3
texld r2, v2, s4
mov r3.y, c2.x
mul_pp r2.xyz, r2.w, r2
mul_pp r2.xyz, r2, c11.w
mul r4.xyz, r2.y, c13
mad r4.xyz, r2.x, c14, r4
mad r3.x, c0.y, r3.y, r3
mad r4.xyz, r2.z, c12, r4
add r0.z, -r0, c3.y
mov r0.w, c2.y
mad r3.y, c0, r0.w, r0.z
texld r3.yw, r3, s2
dp3 r0.z, r4, r4
rsq r2.w, r0.z
mad_pp r3.xy, r3.wyzw, c11.y, c11.z
mul_pp r0.zw, r3.xyxy, r3.xyxy
add_pp_sat r0.z, r0, r0.w
mul r4.xyz, r2.w, r4
add_pp r0.w, -r0.z, c9.y
mad_pp r4.xyz, r1.w, v1, r4
dp3_pp r0.z, r4, r4
rsq_pp r0.w, r0.w
rsq_pp r0.z, r0.z
mul_pp r4.xyz, r0.z, r4
rcp_pp r3.z, r0.w
dp3_pp r0.w, r3, r4
mov_pp r0.z, c7.x
mul_pp r0.z, c13.w, r0
max_pp r0.w, r0, c12
pow r4, r0.w, r0.z
mov r1.w, r4.x
dp3_pp_sat r4.z, r3, c12
dp3_pp_sat r4.y, r3, c13
dp3_pp_sat r4.x, r3, c14
dp3_pp r0.z, r4, r2
texld r3, v2, s3
mul_pp r2.xyz, r3.w, r3
mul_pp r2.xyz, r2, r0.z
mad r0.zw, r1.z, r1.xyxy, v0.xyxy
mul_pp r1.xyz, r2, c11.w
add r0.w, r0, -c3.y
mul r2.w, r0, r0.y
mul r0.w, r0, r0.x
add r0.z, r0, -c3.x
mad r0.y, r0.z, r0, r0.w
mad r0.z, r0, r0.x, -r2.w
add r0.x, -r0.y, c3.y
mov r0.y, c2
mad r0.y, c0, r0, r0.x
add r0.x, -r0.z, c3
mov r0.z, c2.x
mad r0.x, c0.y, r0.z, r0
texld r0, r0, s1
mul_pp r2.xyz, r1, c1
mul_pp r2.xyz, r0.w, r2
mul_pp r0, r0, c6
mul r2.xyz, r2, r1.w
mad_pp oC0.xyz, r0, r1, r2
mov_pp oC0.w, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
ConstBuffer "$Globals" 192 // 136 used size, 13 vars
Vector 32 [_SpecColor] 4
Vector 48 [_PanMT] 4
Vector 64 [_RotMT] 4
Vector 80 [_PanPM] 4
Vector 96 [_RotPM] 4
Vector 112 [_Color] 4
Float 128 [_Shininess]
Float 132 [_Parallax]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_ParallaxMap] 2D 2
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_BumpMap] 2D 1
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
// 71 instructions, 5 temp regs, 0 temp arrays:
// ALU 63 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedegepnapkfmnakhggngmnjmjgegbodbpkabaaaaaabaalaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefccaakaaaaeaaaaaaaiiacaaaafjaaaaaeegiocaaa
aaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
dcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaadcaaaaak
bcaabaaaaaaaaaaadkiacaaaaaaaaaaaagaaaaaaabeaaaaagballgdlabeaaaaa
aaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaanlapejea
dcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaagaaaaaabkiacaaaabaaaaaa
aaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaabcaabaaaabaaaaaa
akaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaaabaaaaaafgiecaia
ebaaaaaaaaaaaaaaagaaaaaadiaaaaahjcaabaaaaaaaaaaaagaabaaaaaaaaaaa
fgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaaaaaaaaaaakaabaaa
abaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaajdcaabaaaaaaaaaaa
egaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaagaaaaaadcaaaaalccaabaaa
abaaaaaabkiacaaaaaaaaaaaafaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaa
aaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaafaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadiaaaaaldcaabaaaaaaaaaaa
bgifcaaaaaaaaaaaaiaaaaaaaceaaaaaaaaaaadpaaaaaaedaaaaaaaaaaaaaaaa
dcaaaaalbcaabaaaaaaaaaaadkaabaaaaaaaaaaabkiacaaaaaaaaaaaaiaaaaaa
akaabaiaebaaaaaaaaaaaaaabaaaaaahecaabaaaaaaaaaaaegbcbaaaacaaaaaa
egbcbaaaacaaaaaaeeaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaadcaaaaaj
icaabaaaaaaaaaaackbabaaaacaaaaaackaabaaaaaaaaaaaabeaaaaadnaknhdo
diaaaaahhcaabaaaabaaaaaakgakbaaaaaaaaaaaegbcbaaaacaaaaaaaoaaaaah
pcaabaaaacaaaaaabgabbaaaabaaaaaapgapbaaaaaaaaaaadcaaaaajpcaabaaa
acaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaabgblbaaaabaaaaaaaaaaaaaj
pcaabaaaacaaaaaaegaobaaaacaaaaaabgibcaiaebaaaaaaaaaaaaaaaeaaaaaa
dcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaagballgdl
abeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
nlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaaeaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaabcaabaaa
adaaaaaaakaabaaaaaaaaaaadiaaaaahpcaabaaaaeaaaaaaagaabaaaaaaaaaaa
egaobaaaacaaaaaadcaaaaakfcaabaaaaaaaaaaafgahbaaaacaaaaaaagaabaaa
adaaaaaaagacbaiaebaaaaaaaeaaaaaadcaaaaajdcaabaaaacaaaaaaigaabaaa
acaaaaaaagaabaaaadaaaaaangafbaaaaeaaaaaaaaaaaaajdcaabaaaacaaaaaa
egaabaiaebaaaaaaacaaaaaafgifcaaaaaaaaaaaaeaaaaaadcaaaaalmcaabaaa
acaaaaaafgifcaaaaaaaaaaaadaaaaaafgifcaaaabaaaaaaaaaaaaaaagaebaaa
acaaaaaaaaaaaaajfcaabaaaaaaaaaaaagacbaiaebaaaaaaaaaaaaaaagiacaaa
aaaaaaaaaeaaaaaadcaaaaaldcaabaaaacaaaaaaagiacaaaaaaaaaaaadaaaaaa
fgifcaaaabaaaaaaaaaaaaaaigaabaaaaaaaaaaaefaaaaajpcaabaaaadaaaaaa
ngafbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaigaabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaadcaaaaap
dcaabaaaadaaaaaahgapbaaaadaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaa
aaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaefaaaaajpcaabaaa
aeaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaah
bcaabaaaaaaaaaaadkaabaaaaeaaaaaaabeaaaaaaaaaaaebdiaaaaahncaabaaa
aaaaaaaaagajbaaaaeaaaaaaagaabaaaaaaaaaaadiaaaaakhcaabaaaaeaaaaaa
kgakbaaaaaaaaaaaaceaaaaaomafnblopdaedfdpdkmnbddpaaaaaaaadcaaaaam
hcaabaaaaeaaaaaaagaabaaaaaaaaaaaaceaaaaaolaffbdpaaaaaaaadkmnbddp
aaaaaaaaegacbaaaaeaaaaaadcaaaaamhcaabaaaaeaaaaaapgapbaaaaaaaaaaa
aceaaaaaolafnblopdaedflpdkmnbddpaaaaaaaaegacbaaaaeaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaaeaaaaaaegacbaaaaeaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaaeaaaaaa
pgapbaaaabaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaapaaaaah
icaabaaaabaaaaaaegaabaaaadaaaaaaegaabaaaadaaaaaaddaaaaahicaabaaa
abaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaaabaaaaaa
dkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaaadaaaaaa
dkaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaa
abaaaaaadeaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaa
cpaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaabaaaaaabjaaaaafccaabaaaaaaaaaaabkaabaaa
aaaaaaaaapcaaaakbcaabaaaabaaaaaaaceaaaaaolaffbdpdkmnbddpaaaaaaaa
aaaaaaaaigaabaaaadaaaaaabacaaaakccaabaaaabaaaaaaaceaaaaaomafnblo
pdaedfdpdkmnbddpaaaaaaaaegacbaaaadaaaaaabacaaaakecaabaaaabaaaaaa
aceaaaaaolafnblopdaedflpdkmnbddpaaaaaaaaegacbaaaadaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaabaaaaaaigadbaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaadaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaah
ecaabaaaaaaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaadiaaaaahncaabaaaaaaaaaaa
agaabaaaaaaaaaaaagajbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaigadbaaa
aaaaaaaaegiccaaaaaaaaaaaacaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaa
egiccaaaaaaaaaaaahaaaaaadiaaaaaiiccabaaaaaaaaaaadkaabaaaacaaaaaa
dkiacaaaaaaaaaaaahaaaaaadiaaaaahncaabaaaaaaaaaaaagaobaaaaaaaaaaa
agajbaaaacaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaafgafbaaa
aaaaaaaaigadbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES3"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
		Blend SrcAlpha One
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 26 to 35
//   d3d9 - ALU: 29 to 38
//   d3d11 - ALU: 24 to 33, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 19 [unity_Scale]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"3.0-!!ARBvp1.0
# 34 ALU
PARAM c[22] = { { 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R1, c[18];
MOV R0.w, c[0].x;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[19].w, -vertex.position;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[17];
DP4 R3.z, R0, c[11];
DP4 R3.x, R0, c[9];
DP4 R3.y, R0, c[10];
MAD R0.xyz, R3, c[19].w, -vertex.position;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 34 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 18 [unity_Scale]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"vs_3_0
; 37 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c21, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r1.xyz, v1
mov r0, c10
dp4 r3.z, c17, r0
mov r0, c9
dp4 r3.y, c17, r0
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
mov r1, c8
dp4 r3.x, c17, r1
mad r0.xyz, r3, c18.w, -v0
mul r2.xyz, r2, v1.w
mov r1.xyz, c16
mov r1.w, c21.x
dp3 o3.y, r2, r0
dp3 o3.z, v2, r0
dp3 o3.x, v1, r0
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c18.w, -v0
dp3 o2.y, r1, r2
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
dp4 o4.z, r0, c14
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.zw, v3.xyxy, c20.xyxy, c20
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 240 // 240 used size, 13 vars
Matrix 48 [_LightMatrix0] 4
Vector 208 [_MainTex_ST] 4
Vector 224 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 34 instructions, 2 temp regs, 0 temp arrays:
// ALU 33 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcdameokfbbhnbjglgnlppmjkbmmghkfjabaaaaaaceahaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefciiafaaaaeaaaabaa
gcabaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaa
kgiocaaaaaaaaaaaaoaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaa
cgbjbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaa
abaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgbpbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaa
adaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaacaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaacaaaaaaaaaaaaaa
egiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
baaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaa
acaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaah
cccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaa
adaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaadaaaaaa
egbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
aaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
aaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
aeaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump float h_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_4.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_ParallaxMap, tmpvar_4).w;
  h_3 = tmpvar_5;
  highp vec2 tmpvar_6;
  mediump float height_7;
  height_7 = _Parallax;
  mediump vec3 viewDir_8;
  viewDir_8 = xlv_TEXCOORD1;
  highp vec3 v_9;
  mediump float tmpvar_10;
  tmpvar_10 = ((h_3 * height_7) - (height_7 / 2.0));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(viewDir_8);
  v_9 = tmpvar_11;
  v_9.z = (v_9.z + 0.42);
  tmpvar_6 = (tmpvar_10 * (v_9.xy / v_9.z));
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.xy + tmpvar_6);
  highp vec2 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.zw + tmpvar_6);
  highp vec2 tmpvar_14;
  tmpvar_14.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_14.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_MainTex, tmpvar_14);
  lowp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15.xyz * _Color.xyz);
  lowp float tmpvar_17;
  tmpvar_17 = (tmpvar_15.w * _Color.w);
  highp vec2 tmpvar_18;
  tmpvar_18.x = ((_RotMT.x - (((tmpvar_13.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_13.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_18.y = ((_RotMT.y - (((tmpvar_13.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_13.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 tmpvar_19;
  tmpvar_19 = ((texture2D (_BumpMap, tmpvar_18).xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize(xlv_TEXCOORD1);
  highp float tmpvar_22;
  tmpvar_22 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  mediump vec3 viewDir_23;
  viewDir_23 = tmpvar_21;
  lowp float atten_24;
  atten_24 = texture2D (_LightTexture0, vec2(tmpvar_22)).w;
  lowp vec4 c_25;
  highp float nh_26;
  lowp float tmpvar_27;
  tmpvar_27 = max (0.0, dot (tmpvar_19, lightDir_2));
  mediump float tmpvar_28;
  tmpvar_28 = max (0.0, dot (tmpvar_19, normalize((lightDir_2 + viewDir_23))));
  nh_26 = tmpvar_28;
  mediump float arg1_29;
  arg1_29 = (_Shininess * 128.0);
  highp float tmpvar_30;
  tmpvar_30 = (pow (nh_26, arg1_29) * tmpvar_15.w);
  highp vec3 tmpvar_31;
  tmpvar_31 = ((((tmpvar_16 * _LightColor0.xyz) * tmpvar_27) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_30)) * (atten_24 * 2.0));
  c_25.xyz = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_17 + (((_LightColor0.w * _SpecColor.w) * tmpvar_30) * atten_24));
  c_25.w = tmpvar_32;
  c_1.xyz = c_25.xyz;
  c_1.w = tmpvar_17;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump float h_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_4.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_ParallaxMap, tmpvar_4).w;
  h_3 = tmpvar_5;
  highp vec2 tmpvar_6;
  mediump float height_7;
  height_7 = _Parallax;
  mediump vec3 viewDir_8;
  viewDir_8 = xlv_TEXCOORD1;
  highp vec3 v_9;
  mediump float tmpvar_10;
  tmpvar_10 = ((h_3 * height_7) - (height_7 / 2.0));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(viewDir_8);
  v_9 = tmpvar_11;
  v_9.z = (v_9.z + 0.42);
  tmpvar_6 = (tmpvar_10 * (v_9.xy / v_9.z));
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.xy + tmpvar_6);
  highp vec2 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.zw + tmpvar_6);
  highp vec2 tmpvar_14;
  tmpvar_14.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_14.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_MainTex, tmpvar_14);
  lowp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15.xyz * _Color.xyz);
  lowp float tmpvar_17;
  tmpvar_17 = (tmpvar_15.w * _Color.w);
  highp vec2 tmpvar_18;
  tmpvar_18.x = ((_RotMT.x - (((tmpvar_13.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_13.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_18.y = ((_RotMT.y - (((tmpvar_13.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_13.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 normal_19;
  normal_19.xy = ((texture2D (_BumpMap, tmpvar_18).wy * 2.0) - 1.0);
  normal_19.z = sqrt((1.0 - clamp (dot (normal_19.xy, normal_19.xy), 0.0, 1.0)));
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize(xlv_TEXCOORD1);
  highp float tmpvar_22;
  tmpvar_22 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  mediump vec3 viewDir_23;
  viewDir_23 = tmpvar_21;
  lowp float atten_24;
  atten_24 = texture2D (_LightTexture0, vec2(tmpvar_22)).w;
  lowp vec4 c_25;
  highp float nh_26;
  lowp float tmpvar_27;
  tmpvar_27 = max (0.0, dot (normal_19, lightDir_2));
  mediump float tmpvar_28;
  tmpvar_28 = max (0.0, dot (normal_19, normalize((lightDir_2 + viewDir_23))));
  nh_26 = tmpvar_28;
  mediump float arg1_29;
  arg1_29 = (_Shininess * 128.0);
  highp float tmpvar_30;
  tmpvar_30 = (pow (nh_26, arg1_29) * tmpvar_15.w);
  highp vec3 tmpvar_31;
  tmpvar_31 = ((((tmpvar_16 * _LightColor0.xyz) * tmpvar_27) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_30)) * (atten_24 * 2.0));
  c_25.xyz = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_17 + (((_LightColor0.w * _SpecColor.w) * tmpvar_30) * atten_24));
  c_25.w = tmpvar_32;
  c_1.xyz = c_25.xyz;
  c_1.w = tmpvar_17;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
#line 397
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
#line 401
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 410
#line 435
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
#line 82
highp vec3 ObjSpaceLightDir( in highp vec4 v ) {
    highp vec3 objSpaceLightPos = (_World2Object * _WorldSpaceLightPos0).xyz;
    return ((objSpaceLightPos.xyz * unity_Scale.w) - v.xyz);
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 437
v2f_surf vert_surf( in appdata_full v ) {
    #line 439
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
    #line 443
    highp vec3 binormal = (cross( v.normal, v.tangent.xyz) * v.tangent.w);
    highp mat3 rotation = xll_transpose_mf3x3(mat3( v.tangent.xyz, binormal, v.normal));
    highp vec3 lightDir = (rotation * ObjSpaceLightDir( v.vertex));
    o.lightDir = lightDir;
    #line 447
    highp vec3 viewDirForLight = (rotation * ObjSpaceViewDir( v.vertex));
    o.viewDir = viewDirForLight;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xyz;
    #line 451
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD3 = vec3(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
#line 397
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
#line 401
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 410
#line 435
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 166
highp vec2 ParallaxOffset( in mediump float h, in mediump float height, in mediump vec3 viewDir ) {
    h = ((h * height) - (height / 2.0));
    highp vec3 v = normalize(viewDir);
    #line 170
    v.z += 0.42;
    return (h * (v.xy / v.z));
}
#line 272
lowp vec3 UnpackNormal( in lowp vec4 packednormal ) {
    #line 274
    return ((packednormal.xyz * 2.0) - 1.0);
}
#line 410
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanPM = vec2( ((_RotPM.x - (((IN.uv_BumpMap.x - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y)), ((_RotPM.y - (((IN.uv_BumpMap.x - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y)));
    mediump float h = texture( _ParallaxMap, UV_PanPM).w;
    #line 414
    highp vec2 offset = ParallaxOffset( h, _Parallax, IN.viewDir);
    IN.uv_MainTex += offset;
    IN.uv_BumpMap += offset;
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    #line 418
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    o.Albedo = (tex.xyz * _Color.xyz);
    o.Gloss = tex.w;
    o.Alpha = (tex.w * _Color.w);
    #line 422
    o.Specular = _Shininess;
    highp vec2 UV_PanBM = vec2( ((_RotMT.x - (((IN.uv_BumpMap.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_BumpMap.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    o.Normal = UnpackNormal( texture( _BumpMap, UV_PanBM));
}
#line 453
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 455
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_BumpMap = IN.pack0.zw;
    surfIN.viewDir = IN.viewDir;
    #line 459
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 463
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp vec3 lightDir = normalize(IN.lightDir);
    #line 467
    lowp vec4 c = LightingBlinnPhong( o, lightDir, normalize(IN.viewDir), (texture( _LightTexture0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * 1.0));
    c.w = o.Alpha;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 5 [_World2Object]
Vector 11 [unity_Scale]
Vector 12 [_MainTex_ST]
Vector 13 [_BumpMap_ST]
"3.0-!!ARBvp1.0
# 26 ALU
PARAM c[14] = { { 1 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0.xyz, c[9];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[7];
DP4 R2.x, R0, c[5];
DP4 R2.y, R0, c[6];
MAD R0.xyz, R2, c[11].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[10];
DP4 R3.z, R1, c[7];
DP4 R3.x, R1, c[5];
DP4 R3.y, R1, c[6];
DP3 result.texcoord[1].y, R0, R2;
DP3 result.texcoord[2].y, R2, R3;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP3 result.texcoord[2].z, vertex.normal, R3;
DP3 result.texcoord[2].x, vertex.attrib[14], R3;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[13].xyxy, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[12], c[12].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 26 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_WorldSpaceLightPos0]
Matrix 4 [_World2Object]
Vector 10 [unity_Scale]
Vector 11 [_MainTex_ST]
Vector 12 [_BumpMap_ST]
"vs_3_0
; 29 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c13, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c6
dp4 r4.z, c9, r0
mov r0, c5
mov r1.w, c13.x
mov r1.xyz, c8
dp4 r4.y, c9, r0
dp4 r2.z, r1, c6
dp4 r2.x, r1, c4
dp4 r2.y, r1, c5
mad r2.xyz, r2, c10.w, -v0
mov r1, c4
dp4 r4.x, c9, r1
dp3 o2.y, r2, r3
dp3 o3.y, r3, r4
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o3.z, v2, r4
dp3 o3.x, v1, r4
mad o1.zw, v3.xyxy, c12.xyxy, c12
mad o1.xy, v3, c11, c11.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 176 used size, 12 vars
Vector 144 [_MainTex_ST] 4
Vector 160 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 25 instructions, 2 temp regs, 0 temp arrays:
// ALU 24 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedjediogjdflnpbimlblngcabdadpdekhfabaaaaaakeafaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
caaeaaaaeaaaabaaaiabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaae
egiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaa
aaaaaaaaakaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaa
egacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgbpbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
egiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaa
abaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaadaaaaaa
bdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaadaaaaaa
beaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaacaaaaaaaaaaaaaaegiccaaa
adaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabaaaaaaa
agiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaaacaaaaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES


#ifdef VERTEX

varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump float h_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_4.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_ParallaxMap, tmpvar_4).w;
  h_3 = tmpvar_5;
  highp vec2 tmpvar_6;
  mediump float height_7;
  height_7 = _Parallax;
  mediump vec3 viewDir_8;
  viewDir_8 = xlv_TEXCOORD1;
  highp vec3 v_9;
  mediump float tmpvar_10;
  tmpvar_10 = ((h_3 * height_7) - (height_7 / 2.0));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(viewDir_8);
  v_9 = tmpvar_11;
  v_9.z = (v_9.z + 0.42);
  tmpvar_6 = (tmpvar_10 * (v_9.xy / v_9.z));
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.xy + tmpvar_6);
  highp vec2 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.zw + tmpvar_6);
  highp vec2 tmpvar_14;
  tmpvar_14.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_14.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_MainTex, tmpvar_14);
  lowp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15.xyz * _Color.xyz);
  lowp float tmpvar_17;
  tmpvar_17 = (tmpvar_15.w * _Color.w);
  highp vec2 tmpvar_18;
  tmpvar_18.x = ((_RotMT.x - (((tmpvar_13.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_13.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_18.y = ((_RotMT.y - (((tmpvar_13.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_13.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 tmpvar_19;
  tmpvar_19 = ((texture2D (_BumpMap, tmpvar_18).xyz * 2.0) - 1.0);
  lightDir_2 = xlv_TEXCOORD2;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize(xlv_TEXCOORD1);
  mediump vec3 viewDir_21;
  viewDir_21 = tmpvar_20;
  lowp vec4 c_22;
  highp float nh_23;
  lowp float tmpvar_24;
  tmpvar_24 = max (0.0, dot (tmpvar_19, lightDir_2));
  mediump float tmpvar_25;
  tmpvar_25 = max (0.0, dot (tmpvar_19, normalize((lightDir_2 + viewDir_21))));
  nh_23 = tmpvar_25;
  mediump float arg1_26;
  arg1_26 = (_Shininess * 128.0);
  highp float tmpvar_27;
  tmpvar_27 = (pow (nh_23, arg1_26) * tmpvar_15.w);
  highp vec3 tmpvar_28;
  tmpvar_28 = ((((tmpvar_16 * _LightColor0.xyz) * tmpvar_24) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_27)) * 2.0);
  c_22.xyz = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = (tmpvar_17 + ((_LightColor0.w * _SpecColor.w) * tmpvar_27));
  c_22.w = tmpvar_29;
  c_1.xyz = c_22.xyz;
  c_1.w = tmpvar_17;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES


#ifdef VERTEX

varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump float h_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_4.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_ParallaxMap, tmpvar_4).w;
  h_3 = tmpvar_5;
  highp vec2 tmpvar_6;
  mediump float height_7;
  height_7 = _Parallax;
  mediump vec3 viewDir_8;
  viewDir_8 = xlv_TEXCOORD1;
  highp vec3 v_9;
  mediump float tmpvar_10;
  tmpvar_10 = ((h_3 * height_7) - (height_7 / 2.0));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(viewDir_8);
  v_9 = tmpvar_11;
  v_9.z = (v_9.z + 0.42);
  tmpvar_6 = (tmpvar_10 * (v_9.xy / v_9.z));
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.xy + tmpvar_6);
  highp vec2 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.zw + tmpvar_6);
  highp vec2 tmpvar_14;
  tmpvar_14.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_14.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_MainTex, tmpvar_14);
  lowp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15.xyz * _Color.xyz);
  lowp float tmpvar_17;
  tmpvar_17 = (tmpvar_15.w * _Color.w);
  highp vec2 tmpvar_18;
  tmpvar_18.x = ((_RotMT.x - (((tmpvar_13.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_13.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_18.y = ((_RotMT.y - (((tmpvar_13.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_13.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 normal_19;
  normal_19.xy = ((texture2D (_BumpMap, tmpvar_18).wy * 2.0) - 1.0);
  normal_19.z = sqrt((1.0 - clamp (dot (normal_19.xy, normal_19.xy), 0.0, 1.0)));
  lightDir_2 = xlv_TEXCOORD2;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize(xlv_TEXCOORD1);
  mediump vec3 viewDir_21;
  viewDir_21 = tmpvar_20;
  lowp vec4 c_22;
  highp float nh_23;
  lowp float tmpvar_24;
  tmpvar_24 = max (0.0, dot (normal_19, lightDir_2));
  mediump float tmpvar_25;
  tmpvar_25 = max (0.0, dot (normal_19, normalize((lightDir_2 + viewDir_21))));
  nh_23 = tmpvar_25;
  mediump float arg1_26;
  arg1_26 = (_Shininess * 128.0);
  highp float tmpvar_27;
  tmpvar_27 = (pow (nh_23, arg1_26) * tmpvar_15.w);
  highp vec3 tmpvar_28;
  tmpvar_28 = ((((tmpvar_16 * _LightColor0.xyz) * tmpvar_24) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_27)) * 2.0);
  c_22.xyz = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = (tmpvar_17 + ((_LightColor0.w * _SpecColor.w) * tmpvar_27));
  c_22.w = tmpvar_29;
  c_1.xyz = c_22.xyz;
  c_1.w = tmpvar_17;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    mediump vec3 lightDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
#line 393
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
#line 397
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 408
#line 432
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
#line 449
#line 82
highp vec3 ObjSpaceLightDir( in highp vec4 v ) {
    highp vec3 objSpaceLightPos = (_World2Object * _WorldSpaceLightPos0).xyz;
    return objSpaceLightPos.xyz;
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 434
v2f_surf vert_surf( in appdata_full v ) {
    #line 436
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
    #line 440
    highp vec3 binormal = (cross( v.normal, v.tangent.xyz) * v.tangent.w);
    highp mat3 rotation = xll_transpose_mf3x3(mat3( v.tangent.xyz, binormal, v.normal));
    highp vec3 lightDir = (rotation * ObjSpaceLightDir( v.vertex));
    o.lightDir = lightDir;
    #line 444
    highp vec3 viewDirForLight = (rotation * ObjSpaceViewDir( v.vertex));
    o.viewDir = viewDirForLight;
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 424
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    mediump vec3 lightDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
#line 393
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
#line 397
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 408
#line 432
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
#line 449
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 166
highp vec2 ParallaxOffset( in mediump float h, in mediump float height, in mediump vec3 viewDir ) {
    h = ((h * height) - (height / 2.0));
    highp vec3 v = normalize(viewDir);
    #line 170
    v.z += 0.42;
    return (h * (v.xy / v.z));
}
#line 272
lowp vec3 UnpackNormal( in lowp vec4 packednormal ) {
    #line 274
    return ((packednormal.xyz * 2.0) - 1.0);
}
#line 408
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanPM = vec2( ((_RotPM.x - (((IN.uv_BumpMap.x - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y)), ((_RotPM.y - (((IN.uv_BumpMap.x - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y)));
    mediump float h = texture( _ParallaxMap, UV_PanPM).w;
    #line 412
    highp vec2 offset = ParallaxOffset( h, _Parallax, IN.viewDir);
    IN.uv_MainTex += offset;
    IN.uv_BumpMap += offset;
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    #line 416
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    o.Albedo = (tex.xyz * _Color.xyz);
    o.Gloss = tex.w;
    o.Alpha = (tex.w * _Color.w);
    #line 420
    o.Specular = _Shininess;
    highp vec2 UV_PanBM = vec2( ((_RotMT.x - (((IN.uv_BumpMap.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_BumpMap.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    o.Normal = UnpackNormal( texture( _BumpMap, UV_PanBM));
}
#line 449
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 453
    surfIN.uv_BumpMap = IN.pack0.zw;
    surfIN.viewDir = IN.viewDir;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 457
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 461
    surf( surfIN, o);
    lowp vec3 lightDir = IN.lightDir;
    lowp vec4 c = LightingBlinnPhong( o, lightDir, normalize(IN.viewDir), 1.0);
    c.w = o.Alpha;
    #line 465
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 19 [unity_Scale]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"3.0-!!ARBvp1.0
# 35 ALU
PARAM c[22] = { { 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R1, c[18];
MOV R0.w, c[0].x;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[19].w, -vertex.position;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[17];
DP4 R3.z, R0, c[11];
DP4 R3.x, R0, c[9];
DP4 R3.y, R0, c[10];
MAD R0.xyz, R3, c[19].w, -vertex.position;
DP4 R0.w, vertex.position, c[8];
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].w, R0, c[16];
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 18 [unity_Scale]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"vs_3_0
; 38 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c21, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r1.xyz, v1
mov r0, c10
dp4 r3.z, c17, r0
mov r0, c9
dp4 r3.y, c17, r0
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
mov r1, c8
dp4 r3.x, c17, r1
mad r0.xyz, r3, c18.w, -v0
mul r2.xyz, r2, v1.w
mov r1.xyz, c16
mov r1.w, c21.x
dp4 r0.w, v0, c7
dp3 o3.y, r2, r0
dp3 o3.z, v2, r0
dp3 o3.x, v1, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c18.w, -v0
dp3 o2.y, r1, r2
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
dp4 o4.w, r0, c15
dp4 o4.z, r0, c14
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.zw, v3.xyxy, c20.xyxy, c20
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 240 // 240 used size, 13 vars
Matrix 48 [_LightMatrix0] 4
Vector 208 [_MainTex_ST] 4
Vector 224 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 34 instructions, 2 temp regs, 0 temp arrays:
// ALU 33 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedahjnghnnndjbhdjheakbaffhdkdaaolgabaaaaaaceahaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefciiafaaaaeaaaabaa
gcabaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaa
kgiocaaaaaaaaaaaaoaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaa
cgbjbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaa
abaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgbpbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaa
adaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaacaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaacaaaaaaaaaaaaaa
egiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
baaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaa
acaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaah
cccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaa
adaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaadaaaaaa
egbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaa
aaaaaaaaaeaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaadaaaaaa
agaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
aaaaaaaaafaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaa
aeaaaaaaegiocaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump float h_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_4.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_ParallaxMap, tmpvar_4).w;
  h_3 = tmpvar_5;
  highp vec2 tmpvar_6;
  mediump float height_7;
  height_7 = _Parallax;
  mediump vec3 viewDir_8;
  viewDir_8 = xlv_TEXCOORD1;
  highp vec3 v_9;
  mediump float tmpvar_10;
  tmpvar_10 = ((h_3 * height_7) - (height_7 / 2.0));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(viewDir_8);
  v_9 = tmpvar_11;
  v_9.z = (v_9.z + 0.42);
  tmpvar_6 = (tmpvar_10 * (v_9.xy / v_9.z));
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.xy + tmpvar_6);
  highp vec2 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.zw + tmpvar_6);
  highp vec2 tmpvar_14;
  tmpvar_14.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_14.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_MainTex, tmpvar_14);
  lowp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15.xyz * _Color.xyz);
  lowp float tmpvar_17;
  tmpvar_17 = (tmpvar_15.w * _Color.w);
  highp vec2 tmpvar_18;
  tmpvar_18.x = ((_RotMT.x - (((tmpvar_13.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_13.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_18.y = ((_RotMT.y - (((tmpvar_13.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_13.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 tmpvar_19;
  tmpvar_19 = ((texture2D (_BumpMap, tmpvar_18).xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize(xlv_TEXCOORD1);
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5);
  highp float tmpvar_23;
  tmpvar_23 = dot (xlv_TEXCOORD3.xyz, xlv_TEXCOORD3.xyz);
  mediump vec3 viewDir_24;
  viewDir_24 = tmpvar_21;
  lowp float atten_25;
  atten_25 = ((float((xlv_TEXCOORD3.z > 0.0)) * texture2D (_LightTexture0, P_22).w) * texture2D (_LightTextureB0, vec2(tmpvar_23)).w);
  lowp vec4 c_26;
  highp float nh_27;
  lowp float tmpvar_28;
  tmpvar_28 = max (0.0, dot (tmpvar_19, lightDir_2));
  mediump float tmpvar_29;
  tmpvar_29 = max (0.0, dot (tmpvar_19, normalize((lightDir_2 + viewDir_24))));
  nh_27 = tmpvar_29;
  mediump float arg1_30;
  arg1_30 = (_Shininess * 128.0);
  highp float tmpvar_31;
  tmpvar_31 = (pow (nh_27, arg1_30) * tmpvar_15.w);
  highp vec3 tmpvar_32;
  tmpvar_32 = ((((tmpvar_16 * _LightColor0.xyz) * tmpvar_28) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_31)) * (atten_25 * 2.0));
  c_26.xyz = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = (tmpvar_17 + (((_LightColor0.w * _SpecColor.w) * tmpvar_31) * atten_25));
  c_26.w = tmpvar_33;
  c_1.xyz = c_26.xyz;
  c_1.w = tmpvar_17;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump float h_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_4.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_ParallaxMap, tmpvar_4).w;
  h_3 = tmpvar_5;
  highp vec2 tmpvar_6;
  mediump float height_7;
  height_7 = _Parallax;
  mediump vec3 viewDir_8;
  viewDir_8 = xlv_TEXCOORD1;
  highp vec3 v_9;
  mediump float tmpvar_10;
  tmpvar_10 = ((h_3 * height_7) - (height_7 / 2.0));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(viewDir_8);
  v_9 = tmpvar_11;
  v_9.z = (v_9.z + 0.42);
  tmpvar_6 = (tmpvar_10 * (v_9.xy / v_9.z));
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.xy + tmpvar_6);
  highp vec2 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.zw + tmpvar_6);
  highp vec2 tmpvar_14;
  tmpvar_14.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_14.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_MainTex, tmpvar_14);
  lowp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15.xyz * _Color.xyz);
  lowp float tmpvar_17;
  tmpvar_17 = (tmpvar_15.w * _Color.w);
  highp vec2 tmpvar_18;
  tmpvar_18.x = ((_RotMT.x - (((tmpvar_13.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_13.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_18.y = ((_RotMT.y - (((tmpvar_13.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_13.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 normal_19;
  normal_19.xy = ((texture2D (_BumpMap, tmpvar_18).wy * 2.0) - 1.0);
  normal_19.z = sqrt((1.0 - clamp (dot (normal_19.xy, normal_19.xy), 0.0, 1.0)));
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize(xlv_TEXCOORD1);
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5);
  highp float tmpvar_23;
  tmpvar_23 = dot (xlv_TEXCOORD3.xyz, xlv_TEXCOORD3.xyz);
  mediump vec3 viewDir_24;
  viewDir_24 = tmpvar_21;
  lowp float atten_25;
  atten_25 = ((float((xlv_TEXCOORD3.z > 0.0)) * texture2D (_LightTexture0, P_22).w) * texture2D (_LightTextureB0, vec2(tmpvar_23)).w);
  lowp vec4 c_26;
  highp float nh_27;
  lowp float tmpvar_28;
  tmpvar_28 = max (0.0, dot (normal_19, lightDir_2));
  mediump float tmpvar_29;
  tmpvar_29 = max (0.0, dot (normal_19, normalize((lightDir_2 + viewDir_24))));
  nh_27 = tmpvar_29;
  mediump float arg1_30;
  arg1_30 = (_Shininess * 128.0);
  highp float tmpvar_31;
  tmpvar_31 = (pow (nh_27, arg1_30) * tmpvar_15.w);
  highp vec3 tmpvar_32;
  tmpvar_32 = ((((tmpvar_16 * _LightColor0.xyz) * tmpvar_28) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_31)) * (atten_25 * 2.0));
  c_26.xyz = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = (tmpvar_17 + (((_LightColor0.w * _SpecColor.w) * tmpvar_31) * atten_25));
  c_26.w = tmpvar_33;
  c_1.xyz = c_26.xyz;
  c_1.w = tmpvar_17;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 412
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 435
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    mediump vec3 lightDir;
    highp vec4 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
#line 398
#line 402
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
#line 406
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
#line 410
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 419
#line 444
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
#line 82
highp vec3 ObjSpaceLightDir( in highp vec4 v ) {
    highp vec3 objSpaceLightPos = (_World2Object * _WorldSpaceLightPos0).xyz;
    return ((objSpaceLightPos.xyz * unity_Scale.w) - v.xyz);
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 446
v2f_surf vert_surf( in appdata_full v ) {
    #line 448
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
    #line 452
    highp vec3 binormal = (cross( v.normal, v.tangent.xyz) * v.tangent.w);
    highp mat3 rotation = xll_transpose_mf3x3(mat3( v.tangent.xyz, binormal, v.normal));
    highp vec3 lightDir = (rotation * ObjSpaceLightDir( v.vertex));
    o.lightDir = lightDir;
    #line 456
    highp vec3 viewDirForLight = (rotation * ObjSpaceViewDir( v.vertex));
    o.viewDir = viewDirForLight;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex));
    #line 460
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD3 = vec4(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 412
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 435
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    mediump vec3 lightDir;
    highp vec4 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
#line 398
#line 402
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
#line 406
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
#line 410
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 419
#line 444
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 398
lowp float UnitySpotAttenuate( in highp vec3 LightCoord ) {
    return texture( _LightTextureB0, vec2( dot( LightCoord, LightCoord))).w;
}
#line 394
lowp float UnitySpotCookie( in highp vec4 LightCoord ) {
    return texture( _LightTexture0, ((LightCoord.xy / LightCoord.w) + 0.5)).w;
}
#line 166
highp vec2 ParallaxOffset( in mediump float h, in mediump float height, in mediump vec3 viewDir ) {
    h = ((h * height) - (height / 2.0));
    highp vec3 v = normalize(viewDir);
    #line 170
    v.z += 0.42;
    return (h * (v.xy / v.z));
}
#line 272
lowp vec3 UnpackNormal( in lowp vec4 packednormal ) {
    #line 274
    return ((packednormal.xyz * 2.0) - 1.0);
}
#line 419
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanPM = vec2( ((_RotPM.x - (((IN.uv_BumpMap.x - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y)), ((_RotPM.y - (((IN.uv_BumpMap.x - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y)));
    mediump float h = texture( _ParallaxMap, UV_PanPM).w;
    #line 423
    highp vec2 offset = ParallaxOffset( h, _Parallax, IN.viewDir);
    IN.uv_MainTex += offset;
    IN.uv_BumpMap += offset;
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    #line 427
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    o.Albedo = (tex.xyz * _Color.xyz);
    o.Gloss = tex.w;
    o.Alpha = (tex.w * _Color.w);
    #line 431
    o.Specular = _Shininess;
    highp vec2 UV_PanBM = vec2( ((_RotMT.x - (((IN.uv_BumpMap.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_BumpMap.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    o.Normal = UnpackNormal( texture( _BumpMap, UV_PanBM));
}
#line 462
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 464
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_BumpMap = IN.pack0.zw;
    surfIN.viewDir = IN.viewDir;
    #line 468
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 472
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp vec3 lightDir = normalize(IN.lightDir);
    #line 476
    lowp vec4 c = LightingBlinnPhong( o, lightDir, normalize(IN.viewDir), (((float((IN._LightCoord.z > 0.0)) * UnitySpotCookie( IN._LightCoord)) * UnitySpotAttenuate( IN._LightCoord.xyz)) * 1.0));
    c.w = o.Alpha;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 19 [unity_Scale]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"3.0-!!ARBvp1.0
# 34 ALU
PARAM c[22] = { { 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R1, c[18];
MOV R0.w, c[0].x;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[19].w, -vertex.position;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[17];
DP4 R3.z, R0, c[11];
DP4 R3.x, R0, c[9];
DP4 R3.y, R0, c[10];
MAD R0.xyz, R3, c[19].w, -vertex.position;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 34 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 18 [unity_Scale]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"vs_3_0
; 37 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c21, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r1.xyz, v1
mov r0, c10
dp4 r3.z, c17, r0
mov r0, c9
dp4 r3.y, c17, r0
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
mov r1, c8
dp4 r3.x, c17, r1
mad r0.xyz, r3, c18.w, -v0
mul r2.xyz, r2, v1.w
mov r1.xyz, c16
mov r1.w, c21.x
dp3 o3.y, r2, r0
dp3 o3.z, v2, r0
dp3 o3.x, v1, r0
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c18.w, -v0
dp3 o2.y, r1, r2
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
dp4 o4.z, r0, c14
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.zw, v3.xyxy, c20.xyxy, c20
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 240 // 240 used size, 13 vars
Matrix 48 [_LightMatrix0] 4
Vector 208 [_MainTex_ST] 4
Vector 224 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 34 instructions, 2 temp regs, 0 temp arrays:
// ALU 33 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcdameokfbbhnbjglgnlppmjkbmmghkfjabaaaaaaceahaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefciiafaaaaeaaaabaa
gcabaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaa
kgiocaaaaaaaaaaaaoaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaa
cgbjbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaa
abaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgbpbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaa
adaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaacaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaacaaaaaaaaaaaaaa
egiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
baaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaa
acaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaah
cccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaa
adaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaadaaaaaa
egbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
aaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
aaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
aeaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump float h_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_4.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_ParallaxMap, tmpvar_4).w;
  h_3 = tmpvar_5;
  highp vec2 tmpvar_6;
  mediump float height_7;
  height_7 = _Parallax;
  mediump vec3 viewDir_8;
  viewDir_8 = xlv_TEXCOORD1;
  highp vec3 v_9;
  mediump float tmpvar_10;
  tmpvar_10 = ((h_3 * height_7) - (height_7 / 2.0));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(viewDir_8);
  v_9 = tmpvar_11;
  v_9.z = (v_9.z + 0.42);
  tmpvar_6 = (tmpvar_10 * (v_9.xy / v_9.z));
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.xy + tmpvar_6);
  highp vec2 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.zw + tmpvar_6);
  highp vec2 tmpvar_14;
  tmpvar_14.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_14.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_MainTex, tmpvar_14);
  lowp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15.xyz * _Color.xyz);
  lowp float tmpvar_17;
  tmpvar_17 = (tmpvar_15.w * _Color.w);
  highp vec2 tmpvar_18;
  tmpvar_18.x = ((_RotMT.x - (((tmpvar_13.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_13.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_18.y = ((_RotMT.y - (((tmpvar_13.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_13.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 tmpvar_19;
  tmpvar_19 = ((texture2D (_BumpMap, tmpvar_18).xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize(xlv_TEXCOORD1);
  highp float tmpvar_22;
  tmpvar_22 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  mediump vec3 viewDir_23;
  viewDir_23 = tmpvar_21;
  lowp float atten_24;
  atten_24 = (texture2D (_LightTextureB0, vec2(tmpvar_22)).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w);
  lowp vec4 c_25;
  highp float nh_26;
  lowp float tmpvar_27;
  tmpvar_27 = max (0.0, dot (tmpvar_19, lightDir_2));
  mediump float tmpvar_28;
  tmpvar_28 = max (0.0, dot (tmpvar_19, normalize((lightDir_2 + viewDir_23))));
  nh_26 = tmpvar_28;
  mediump float arg1_29;
  arg1_29 = (_Shininess * 128.0);
  highp float tmpvar_30;
  tmpvar_30 = (pow (nh_26, arg1_29) * tmpvar_15.w);
  highp vec3 tmpvar_31;
  tmpvar_31 = ((((tmpvar_16 * _LightColor0.xyz) * tmpvar_27) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_30)) * (atten_24 * 2.0));
  c_25.xyz = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_17 + (((_LightColor0.w * _SpecColor.w) * tmpvar_30) * atten_24));
  c_25.w = tmpvar_32;
  c_1.xyz = c_25.xyz;
  c_1.w = tmpvar_17;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump float h_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_4.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_ParallaxMap, tmpvar_4).w;
  h_3 = tmpvar_5;
  highp vec2 tmpvar_6;
  mediump float height_7;
  height_7 = _Parallax;
  mediump vec3 viewDir_8;
  viewDir_8 = xlv_TEXCOORD1;
  highp vec3 v_9;
  mediump float tmpvar_10;
  tmpvar_10 = ((h_3 * height_7) - (height_7 / 2.0));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(viewDir_8);
  v_9 = tmpvar_11;
  v_9.z = (v_9.z + 0.42);
  tmpvar_6 = (tmpvar_10 * (v_9.xy / v_9.z));
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.xy + tmpvar_6);
  highp vec2 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.zw + tmpvar_6);
  highp vec2 tmpvar_14;
  tmpvar_14.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_14.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_MainTex, tmpvar_14);
  lowp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15.xyz * _Color.xyz);
  lowp float tmpvar_17;
  tmpvar_17 = (tmpvar_15.w * _Color.w);
  highp vec2 tmpvar_18;
  tmpvar_18.x = ((_RotMT.x - (((tmpvar_13.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_13.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_18.y = ((_RotMT.y - (((tmpvar_13.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_13.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 normal_19;
  normal_19.xy = ((texture2D (_BumpMap, tmpvar_18).wy * 2.0) - 1.0);
  normal_19.z = sqrt((1.0 - clamp (dot (normal_19.xy, normal_19.xy), 0.0, 1.0)));
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize(xlv_TEXCOORD1);
  highp float tmpvar_22;
  tmpvar_22 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  mediump vec3 viewDir_23;
  viewDir_23 = tmpvar_21;
  lowp float atten_24;
  atten_24 = (texture2D (_LightTextureB0, vec2(tmpvar_22)).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w);
  lowp vec4 c_25;
  highp float nh_26;
  lowp float tmpvar_27;
  tmpvar_27 = max (0.0, dot (normal_19, lightDir_2));
  mediump float tmpvar_28;
  tmpvar_28 = max (0.0, dot (normal_19, normalize((lightDir_2 + viewDir_23))));
  nh_26 = tmpvar_28;
  mediump float arg1_29;
  arg1_29 = (_Shininess * 128.0);
  highp float tmpvar_30;
  tmpvar_30 = (pow (nh_26, arg1_29) * tmpvar_15.w);
  highp vec3 tmpvar_31;
  tmpvar_31 = ((((tmpvar_16 * _LightColor0.xyz) * tmpvar_27) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_30)) * (atten_24 * 2.0));
  c_25.xyz = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_17 + (((_LightColor0.w * _SpecColor.w) * tmpvar_30) * atten_24));
  c_25.w = tmpvar_32;
  c_1.xyz = c_25.xyz;
  c_1.w = tmpvar_17;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 404
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 427
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform samplerCube _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _PanMT;
#line 397
uniform highp vec4 _RotMT;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
uniform highp vec4 _RotPM;
#line 401
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 411
#line 436
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
#line 82
highp vec3 ObjSpaceLightDir( in highp vec4 v ) {
    highp vec3 objSpaceLightPos = (_World2Object * _WorldSpaceLightPos0).xyz;
    return ((objSpaceLightPos.xyz * unity_Scale.w) - v.xyz);
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 438
v2f_surf vert_surf( in appdata_full v ) {
    #line 440
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
    #line 444
    highp vec3 binormal = (cross( v.normal, v.tangent.xyz) * v.tangent.w);
    highp mat3 rotation = xll_transpose_mf3x3(mat3( v.tangent.xyz, binormal, v.normal));
    highp vec3 lightDir = (rotation * ObjSpaceLightDir( v.vertex));
    o.lightDir = lightDir;
    #line 448
    highp vec3 viewDirForLight = (rotation * ObjSpaceViewDir( v.vertex));
    o.viewDir = viewDirForLight;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xyz;
    #line 452
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD3 = vec3(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 404
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 427
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform samplerCube _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _PanMT;
#line 397
uniform highp vec4 _RotMT;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
uniform highp vec4 _RotPM;
#line 401
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 411
#line 436
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 166
highp vec2 ParallaxOffset( in mediump float h, in mediump float height, in mediump vec3 viewDir ) {
    h = ((h * height) - (height / 2.0));
    highp vec3 v = normalize(viewDir);
    #line 170
    v.z += 0.42;
    return (h * (v.xy / v.z));
}
#line 272
lowp vec3 UnpackNormal( in lowp vec4 packednormal ) {
    #line 274
    return ((packednormal.xyz * 2.0) - 1.0);
}
#line 411
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanPM = vec2( ((_RotPM.x - (((IN.uv_BumpMap.x - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y)), ((_RotPM.y - (((IN.uv_BumpMap.x - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y)));
    mediump float h = texture( _ParallaxMap, UV_PanPM).w;
    #line 415
    highp vec2 offset = ParallaxOffset( h, _Parallax, IN.viewDir);
    IN.uv_MainTex += offset;
    IN.uv_BumpMap += offset;
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    #line 419
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    o.Albedo = (tex.xyz * _Color.xyz);
    o.Gloss = tex.w;
    o.Alpha = (tex.w * _Color.w);
    #line 423
    o.Specular = _Shininess;
    highp vec2 UV_PanBM = vec2( ((_RotMT.x - (((IN.uv_BumpMap.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_BumpMap.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    o.Normal = UnpackNormal( texture( _BumpMap, UV_PanBM));
}
#line 454
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 456
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_BumpMap = IN.pack0.zw;
    surfIN.viewDir = IN.viewDir;
    #line 460
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 464
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp vec3 lightDir = normalize(IN.lightDir);
    #line 468
    lowp vec4 c = LightingBlinnPhong( o, lightDir, normalize(IN.viewDir), ((texture( _LightTextureB0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * texture( _LightTexture0, IN._LightCoord).w) * 1.0));
    c.w = o.Alpha;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 19 [unity_Scale]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"3.0-!!ARBvp1.0
# 32 ALU
PARAM c[22] = { { 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0.w, c[0].x;
MOV R0.xyz, c[17];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[19].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[18];
DP3 result.texcoord[1].y, R0, R2;
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R2, R3;
DP3 result.texcoord[2].z, vertex.normal, R3;
DP3 result.texcoord[2].x, vertex.attrib[14], R3;
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 32 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 18 [unity_Scale]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c21, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c17, r0
mov r0, c9
dp4 r4.y, c17, r0
mov r1.w, c21.x
mov r1.xyz, c16
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c18.w, -v0
mov r1, c8
dp4 r4.x, c17, r1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o2.y, r2, r3
dp3 o3.y, r3, r4
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o3.z, v2, r4
dp3 o3.x, v1, r4
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.zw, v3.xyxy, c20.xyxy, c20
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 240 // 240 used size, 13 vars
Matrix 48 [_LightMatrix0] 4
Vector 208 [_MainTex_ST] 4
Vector 224 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 33 instructions, 2 temp regs, 0 temp arrays:
// ALU 32 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecednobekokbaieoolfocliefmhlppnjfmpdabaaaaaapiagaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcfmafaaaaeaaaabaa
fhabaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaa
kgiocaaaaaaaaaaaaoaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaa
cgbjbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaa
abaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgbpbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaa
adaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaacaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaacaaaaaaaaaaaaaa
egiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
baaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaa
acaaaaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
anaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
dcaabaaaabaaaaaafgafbaaaaaaaaaaaegiacaaaaaaaaaaaaeaaaaaadcaaaaak
dcaabaaaaaaaaaaaegiacaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegaabaaa
abaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaaafaaaaaakgakbaaa
aaaaaaaaegaabaaaaaaaaaaadcaaaaakdccabaaaaeaaaaaaegiacaaaaaaaaaaa
agaaaaaapgapbaaaaaaaaaaaegaabaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump float h_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_4.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_ParallaxMap, tmpvar_4).w;
  h_3 = tmpvar_5;
  highp vec2 tmpvar_6;
  mediump float height_7;
  height_7 = _Parallax;
  mediump vec3 viewDir_8;
  viewDir_8 = xlv_TEXCOORD1;
  highp vec3 v_9;
  mediump float tmpvar_10;
  tmpvar_10 = ((h_3 * height_7) - (height_7 / 2.0));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(viewDir_8);
  v_9 = tmpvar_11;
  v_9.z = (v_9.z + 0.42);
  tmpvar_6 = (tmpvar_10 * (v_9.xy / v_9.z));
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.xy + tmpvar_6);
  highp vec2 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.zw + tmpvar_6);
  highp vec2 tmpvar_14;
  tmpvar_14.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_14.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_MainTex, tmpvar_14);
  lowp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15.xyz * _Color.xyz);
  lowp float tmpvar_17;
  tmpvar_17 = (tmpvar_15.w * _Color.w);
  highp vec2 tmpvar_18;
  tmpvar_18.x = ((_RotMT.x - (((tmpvar_13.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_13.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_18.y = ((_RotMT.y - (((tmpvar_13.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_13.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 tmpvar_19;
  tmpvar_19 = ((texture2D (_BumpMap, tmpvar_18).xyz * 2.0) - 1.0);
  lightDir_2 = xlv_TEXCOORD2;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize(xlv_TEXCOORD1);
  mediump vec3 viewDir_21;
  viewDir_21 = tmpvar_20;
  lowp float atten_22;
  atten_22 = texture2D (_LightTexture0, xlv_TEXCOORD3).w;
  lowp vec4 c_23;
  highp float nh_24;
  lowp float tmpvar_25;
  tmpvar_25 = max (0.0, dot (tmpvar_19, lightDir_2));
  mediump float tmpvar_26;
  tmpvar_26 = max (0.0, dot (tmpvar_19, normalize((lightDir_2 + viewDir_21))));
  nh_24 = tmpvar_26;
  mediump float arg1_27;
  arg1_27 = (_Shininess * 128.0);
  highp float tmpvar_28;
  tmpvar_28 = (pow (nh_24, arg1_27) * tmpvar_15.w);
  highp vec3 tmpvar_29;
  tmpvar_29 = ((((tmpvar_16 * _LightColor0.xyz) * tmpvar_25) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_28)) * (atten_22 * 2.0));
  c_23.xyz = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_17 + (((_LightColor0.w * _SpecColor.w) * tmpvar_28) * atten_22));
  c_23.w = tmpvar_30;
  c_1.xyz = c_23.xyz;
  c_1.w = tmpvar_17;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Parallax;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotPM;
uniform highp vec4 _PanPM;
uniform sampler2D _ParallaxMap;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump float h_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotPM.x - (((xlv_TEXCOORD0.z - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y));
  tmpvar_4.y = ((_RotPM.y - (((xlv_TEXCOORD0.z - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y));
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_ParallaxMap, tmpvar_4).w;
  h_3 = tmpvar_5;
  highp vec2 tmpvar_6;
  mediump float height_7;
  height_7 = _Parallax;
  mediump vec3 viewDir_8;
  viewDir_8 = xlv_TEXCOORD1;
  highp vec3 v_9;
  mediump float tmpvar_10;
  tmpvar_10 = ((h_3 * height_7) - (height_7 / 2.0));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(viewDir_8);
  v_9 = tmpvar_11;
  v_9.z = (v_9.z + 0.42);
  tmpvar_6 = (tmpvar_10 * (v_9.xy / v_9.z));
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.xy + tmpvar_6);
  highp vec2 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.zw + tmpvar_6);
  highp vec2 tmpvar_14;
  tmpvar_14.x = ((_RotMT.x - (((tmpvar_12.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_12.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_14.y = ((_RotMT.y - (((tmpvar_12.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_12.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_MainTex, tmpvar_14);
  lowp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15.xyz * _Color.xyz);
  lowp float tmpvar_17;
  tmpvar_17 = (tmpvar_15.w * _Color.w);
  highp vec2 tmpvar_18;
  tmpvar_18.x = ((_RotMT.x - (((tmpvar_13.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((tmpvar_13.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_18.y = ((_RotMT.y - (((tmpvar_13.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((tmpvar_13.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec3 normal_19;
  normal_19.xy = ((texture2D (_BumpMap, tmpvar_18).wy * 2.0) - 1.0);
  normal_19.z = sqrt((1.0 - clamp (dot (normal_19.xy, normal_19.xy), 0.0, 1.0)));
  lightDir_2 = xlv_TEXCOORD2;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize(xlv_TEXCOORD1);
  mediump vec3 viewDir_21;
  viewDir_21 = tmpvar_20;
  lowp float atten_22;
  atten_22 = texture2D (_LightTexture0, xlv_TEXCOORD3).w;
  lowp vec4 c_23;
  highp float nh_24;
  lowp float tmpvar_25;
  tmpvar_25 = max (0.0, dot (normal_19, lightDir_2));
  mediump float tmpvar_26;
  tmpvar_26 = max (0.0, dot (normal_19, normalize((lightDir_2 + viewDir_21))));
  nh_24 = tmpvar_26;
  mediump float arg1_27;
  arg1_27 = (_Shininess * 128.0);
  highp float tmpvar_28;
  tmpvar_28 = (pow (nh_24, arg1_27) * tmpvar_15.w);
  highp vec3 tmpvar_29;
  tmpvar_29 = ((((tmpvar_16 * _LightColor0.xyz) * tmpvar_25) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_28)) * (atten_22 * 2.0));
  c_23.xyz = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_17 + (((_LightColor0.w * _SpecColor.w) * tmpvar_28) * atten_22));
  c_23.w = tmpvar_30;
  c_1.xyz = c_23.xyz;
  c_1.w = tmpvar_17;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    mediump vec3 lightDir;
    highp vec2 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
#line 397
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
#line 401
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 410
#line 435
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
#line 82
highp vec3 ObjSpaceLightDir( in highp vec4 v ) {
    highp vec3 objSpaceLightPos = (_World2Object * _WorldSpaceLightPos0).xyz;
    return objSpaceLightPos.xyz;
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 437
v2f_surf vert_surf( in appdata_full v ) {
    #line 439
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
    #line 443
    highp vec3 binormal = (cross( v.normal, v.tangent.xyz) * v.tangent.w);
    highp mat3 rotation = xll_transpose_mf3x3(mat3( v.tangent.xyz, binormal, v.normal));
    highp vec3 lightDir = (rotation * ObjSpaceLightDir( v.vertex));
    o.lightDir = lightDir;
    #line 447
    highp vec3 viewDirForLight = (rotation * ObjSpaceViewDir( v.vertex));
    o.viewDir = viewDirForLight;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xy;
    #line 451
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD3 = vec2(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_BumpMap;
    highp vec3 viewDir;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec3 viewDir;
    mediump vec3 lightDir;
    highp vec2 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
#line 397
uniform sampler2D _ParallaxMap;
uniform highp vec4 _PanPM;
uniform highp vec4 _RotPM;
uniform lowp vec4 _Color;
#line 401
uniform mediump float _Shininess;
uniform highp float _Parallax;
#line 410
#line 435
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 166
highp vec2 ParallaxOffset( in mediump float h, in mediump float height, in mediump vec3 viewDir ) {
    h = ((h * height) - (height / 2.0));
    highp vec3 v = normalize(viewDir);
    #line 170
    v.z += 0.42;
    return (h * (v.xy / v.z));
}
#line 272
lowp vec3 UnpackNormal( in lowp vec4 packednormal ) {
    #line 274
    return ((packednormal.xyz * 2.0) - 1.0);
}
#line 410
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanPM = vec2( ((_RotPM.x - (((IN.uv_BumpMap.x - _RotPM.x) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotPM.y) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.x * _Time.y)), ((_RotPM.y - (((IN.uv_BumpMap.x - _RotPM.x) * sin(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotPM.y) * cos(((_RotPM.z * _Time.y) + (3.14159 * (1.0 + (_RotPM.w / 180.0)))))))) + (_PanPM.y * _Time.y)));
    mediump float h = texture( _ParallaxMap, UV_PanPM).w;
    #line 414
    highp vec2 offset = ParallaxOffset( h, _Parallax, IN.viewDir);
    IN.uv_MainTex += offset;
    IN.uv_BumpMap += offset;
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    #line 418
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    o.Albedo = (tex.xyz * _Color.xyz);
    o.Gloss = tex.w;
    o.Alpha = (tex.w * _Color.w);
    #line 422
    o.Specular = _Shininess;
    highp vec2 UV_PanBM = vec2( ((_RotMT.x - (((IN.uv_BumpMap.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_BumpMap.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_BumpMap.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_BumpMap.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    o.Normal = UnpackNormal( texture( _BumpMap, UV_PanBM));
}
#line 453
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 455
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_BumpMap = IN.pack0.zw;
    surfIN.viewDir = IN.viewDir;
    #line 459
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 463
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp vec3 lightDir = IN.lightDir;
    #line 467
    lowp vec4 c = LightingBlinnPhong( o, lightDir, normalize(IN.viewDir), (texture( _LightTexture0, IN._LightCoord).w * 1.0));
    c.w = o.Alpha;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec2(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 85 to 96, TEX: 3 to 5
//   d3d9 - ALU: 109 to 118, TEX: 3 to 5
//   d3d11 - ALU: 52 to 62, TEX: 3 to 5, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_PanPM]
Vector 6 [_RotPM]
Vector 7 [_Color]
Float 8 [_Shininess]
Float 9 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"3.0-!!ARBfp1.0
# 90 ALU, 4 TEX
PARAM c[12] = { program.local[0..9],
		{ 0.0055555557, 1, 3.1415927, 0.5 },
		{ 0.41999999, 2, 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.x, c[6].w;
MAD R0.x, R0, c[10], c[10].y;
MOV R2.w, c[0].y;
MUL R0.x, R0, c[10].z;
MAD R0.x, R2.w, c[6].z, R0;
COS R0.y, R0.x;
SIN R0.z, R0.x;
ADD R0.x, fragment.texcoord[0].w, -c[6].y;
MUL R0.w, R0.x, R0.z;
MUL R1.x, R0.y, R0;
ADD R0.x, fragment.texcoord[0].z, -c[6];
MAD R0.z, R0.x, R0, R1.x;
MAD R0.x, R0, R0.y, -R0.w;
ADD R0.y, -R0.z, c[6];
ADD R0.x, -R0, c[6];
MOV R0.z, c[4].w;
MAD R0.y, R2.w, c[5], R0;
MAD R0.x, R2.w, c[5], R0;
TEX R0.w, R0, texture[0], 2D;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MOV R0.y, c[9].x;
MUL R0.y, R0, c[10].w;
MUL R1.xyz, R0.x, fragment.texcoord[1];
MAD R0.w, R0, c[9].x, -R0.y;
ADD R0.y, R1.z, c[11].x;
RCP R0.y, R0.y;
MUL R3.xy, R1, R0.y;
MAD R0.z, R0, c[10].x, c[10].y;
MUL R0.y, R0.z, c[10].z;
MAD R0.y, R2.w, c[4].z, R0;
MAD R1.xy, R0.w, R3, fragment.texcoord[0].zwzw;
COS R3.z, R0.y;
SIN R3.w, R0.y;
ADD R0.z, R1.y, -c[4].y;
MUL R1.y, R3.w, R0.z;
ADD R0.y, R1.x, -c[4].x;
MUL R0.z, R3, R0;
MAD R0.z, R3.w, R0.y, R0;
MAD R0.y, R3.z, R0, -R1;
ADD R0.z, -R0, c[4].y;
MAD R1.y, R2.w, c[3], R0.z;
ADD R0.y, -R0, c[4].x;
MAD R1.x, R2.w, c[3], R0.y;
DP3 R0.z, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.z, R0.z;
MUL R2.xyz, R0.z, fragment.texcoord[2];
TEX R1.yw, R1, texture[2], 2D;
MOV R0.y, c[10];
MAD R1.xy, R1.wyzw, c[11].y, -R0.y;
MUL R1.zw, R1.xyxy, R1.xyxy;
ADD_SAT R1.z, R1, R1.w;
MAD R0.xyz, R0.x, fragment.texcoord[1], R2;
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
ADD R1.z, -R1, c[10].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R0.x, R1, R0;
MAX R0.z, R0.x, c[11];
MAD R0.xy, R0.w, R3, fragment.texcoord[0];
MOV R1.w, c[11];
MUL R0.w, R1, c[8].x;
DP3 R1.x, R1, R2;
POW R1.w, R0.z, R0.w;
ADD R0.y, R0, -c[4];
MUL R0.z, R0.y, R3.w;
ADD R0.x, R0, -c[4];
MUL R0.y, R3.z, R0;
MAD R0.y, R0.x, R3.w, R0;
MAD R0.x, R0, R3.z, -R0.z;
ADD R0.y, -R0, c[4];
ADD R0.x, -R0, c[4];
MAD R0.y, R2.w, c[3], R0;
MAD R0.x, R2.w, c[3], R0;
TEX R0, R0, texture[1], 2D;
MUL R2, R0, c[7];
MUL R1.w, R0, R1;
MAX R0.w, R1.x, c[11].z;
MUL R0.xyz, R2, c[1];
MUL R0.xyz, R0, R0.w;
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
MOV R1.xyz, c[2];
TEX R0.w, R0.w, texture[3], 2D;
MUL R1.xyz, R1, c[1];
MUL R0.w, R0, c[11].y;
MAD R0.xyz, R1, R1.w, R0;
MUL result.color.xyz, R0, R0.w;
MOV result.color.w, R2;
END
# 90 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_PanPM]
Vector 6 [_RotPM]
Vector 7 [_Color]
Float 8 [_Shininess]
Float 9 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_3_0
; 113 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c10, 0.00555556, 1.00000000, 3.14159274, 0.50000000
def c11, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c12, 0.41999999, 2.00000000, -1.00000000, 0.00000000
def c13, 128.00000000, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
mov r0.x, c6.w
mad r0.x, r0, c10, c10.y
mul r0.y, r0.x, c10.z
mov r0.x, c6.z
mad r0.x, c0.y, r0, r0.y
mad r0.x, r0, c11, c11.y
frc r0.x, r0
mad r1.x, r0, c11.z, c11.w
sincos r0.xy, r1.x
add r0.z, v0.w, -c6.y
mul r1.x, r0.z, r0
mul r0.w, r0.z, r0.y
add r0.z, v0, -c6.x
mad r0.x, r0.z, r0, -r0.w
mad r0.z, r0, r0.y, r1.x
add r0.y, -r0.x, c6.x
add r0.w, -r0.z, c6.y
mov r0.x, c5
mad r0.x, c0.y, r0, r0.y
mov_pp r0.z, c10.w
mov r0.y, c5
mad r0.y, c0, r0, r0.w
texld r0.w, r0, s0
mul_pp r0.z, c9.x, r0
mad_pp r1.w, r0, c9.x, -r0.z
dp3_pp r0.x, v1, v1
rsq_pp r0.z, r0.x
mov r0.y, c4.w
mad r0.x, r0.y, c10, c10.y
mul r0.y, r0.x, c10.z
mov r0.x, c4.z
mad r0.y, c0, r0.x, r0
mul_pp r1.xyz, r0.z, v1
add r0.x, r1.z, c12
rcp r0.x, r0.x
mad r0.y, r0, c11.x, c11
frc r0.y, r0
mad r0.w, r0.y, c11.z, c11
mul r4.xy, r1, r0.x
mad r0.xy, r1.w, r4, v0.zwzw
sincos r3.xy, r0.w
add r0.y, r0, -c4
mul r0.w, r3.y, r0.y
add r0.x, r0, -c4
mad r0.w, r3.x, r0.x, -r0
mul r0.y, r3.x, r0
mad r0.y, r3, r0.x, r0
mov r0.x, c3.y
add r0.y, -r0, c4
mad r0.y, c0, r0.x, r0
add r0.w, -r0, c4.x
mov r0.x, c3
mad r0.x, c0.y, r0, r0.w
texld r0.yw, r0, s2
mad_pp r1.xy, r0.wyzw, c12.y, c12.z
dp3_pp r0.x, v2, v2
rsq_pp r0.w, r0.x
mul_pp r0.xy, r1, r1
mul_pp r2.xyz, r0.w, v2
add_pp_sat r0.w, r0.x, r0.y
mad_pp r0.xyz, r0.z, v1, r2
dp3_pp r1.z, r0, r0
rsq_pp r2.w, r1.z
add_pp r0.w, -r0, c10.y
rsq_pp r0.w, r0.w
rcp_pp r1.z, r0.w
mul_pp r0.xyz, r2.w, r0
dp3_pp r0.x, r1, r0
dp3_pp r1.x, r1, r2
mov_pp r0.w, c8.x
max_pp r2.w, r0.x, c12
mul_pp r3.z, c13.x, r0.w
pow r0, r2.w, r3.z
mad r0.zw, r1.w, r4.xyxy, v0.xyxy
add r0.y, r0.w, -c4
mul r0.w, r0.y, r3.y
mov r1.w, r0.x
add r0.x, r0.z, -c4
mad r0.z, r0.x, r3.x, -r0.w
mul r0.y, r0, r3.x
mad r0.y, r0.x, r3, r0
mov r0.x, c3.y
add r0.y, -r0, c4
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c4.x
mov r0.x, c3
mad r0.x, c0.y, r0, r0.z
texld r0, r0, s1
mul r1.w, r0, r1
mul_pp r0, r0, c7
mul_pp r0.xyz, r0, c1
max_pp r1.x, r1, c12.w
mul_pp r2.xyz, r0, r1.x
dp3 r0.x, v3, v3
texld r0.x, r0.x, s3
mov_pp r1.xyz, c1
mul_pp r2.w, r0.x, c12.y
mul_pp r1.xyz, c2, r1
mad r0.xyz, r1, r1.w, r2
mul oC0.xyz, r0, r2.w
mov_pp oC0.w, r0
"
}

SubProgram "d3d11 " {
Keywords { "POINT" }
ConstBuffer "$Globals" 240 // 200 used size, 13 vars
Vector 16 [_LightColor0] 4
Vector 32 [_SpecColor] 4
Vector 112 [_PanMT] 4
Vector 128 [_RotMT] 4
Vector 144 [_PanPM] 4
Vector 160 [_RotPM] 4
Vector 176 [_Color] 4
Float 192 [_Shininess]
Float 196 [_Parallax]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_ParallaxMap] 2D 3
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_BumpMap] 2D 2
SetTexture 3 [_LightTexture0] 2D 0
// 64 instructions, 5 temp regs, 0 temp arrays:
// ALU 57 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedgioacdddccnijhakfaopdgobholebgahabaaaaaaaiakaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcaaajaaaaeaaaaaaaeaacaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
afaaaaaadcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaakaaaaaaabeaaaaa
gballgdlabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaanlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaakaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaa
bcaabaaaabaaaaaaakaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaa
abaaaaaafgiecaiaebaaaaaaaaaaaaaaakaaaaaadiaaaaahjcaabaaaaaaaaaaa
agaabaaaaaaaaaaafgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaa
aaaaaaaaakaabaaaabaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaaj
dcaabaaaaaaaaaaaegaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaakaaaaaa
dcaaaaalccaabaaaabaaaaaabkiacaaaaaaaaaaaajaaaaaabkiacaaaabaaaaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaa
ajaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaa
aaaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaadaaaaaadiaaaaal
dcaabaaaaaaaaaaabgifcaaaaaaaaaaaamaaaaaaaceaaaaaaaaaaadpaaaaaaed
aaaaaaaaaaaaaaaadcaaaaalbcaabaaaaaaaaaaadkaabaaaaaaaaaaabkiacaaa
aaaaaaaaamaaaaaaakaabaiaebaaaaaaaaaaaaaabaaaaaahecaabaaaaaaaaaaa
egbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaafecaabaaaaaaaaaaackaabaaa
aaaaaaaadcaaaaajicaabaaaaaaaaaaackbabaaaacaaaaaackaabaaaaaaaaaaa
abeaaaaadnaknhdodiaaaaahhcaabaaaabaaaaaakgakbaaaaaaaaaaaegbcbaaa
acaaaaaaaoaaaaahpcaabaaaacaaaaaabgabbaaaabaaaaaapgapbaaaaaaaaaaa
dcaaaaajpcaabaaaacaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaabgblbaaa
abaaaaaaaaaaaaajpcaabaaaacaaaaaaegaobaaaacaaaaaabgibcaiaebaaaaaa
aaaaaaaaaiaaaaaadcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaaiaaaaaa
abeaaaaagballgdlabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaanlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaa
aiaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaa
aaaaaaaabcaabaaaadaaaaaaakaabaaaaaaaaaaadiaaaaahpcaabaaaaeaaaaaa
agaabaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakfcaabaaaaaaaaaaafgahbaaa
acaaaaaaagaabaaaadaaaaaaagacbaiaebaaaaaaaeaaaaaadcaaaaajdcaabaaa
acaaaaaaigaabaaaacaaaaaaagaabaaaadaaaaaangafbaaaaeaaaaaaaaaaaaaj
dcaabaaaacaaaaaaegaabaiaebaaaaaaacaaaaaafgifcaaaaaaaaaaaaiaaaaaa
dcaaaaalmcaabaaaacaaaaaafgifcaaaaaaaaaaaahaaaaaafgifcaaaabaaaaaa
aaaaaaaaagaebaaaacaaaaaaaaaaaaajfcaabaaaaaaaaaaaagacbaiaebaaaaaa
aaaaaaaaagiacaaaaaaaaaaaaiaaaaaadcaaaaaldcaabaaaacaaaaaaagiacaaa
aaaaaaaaahaaaaaafgifcaaaabaaaaaaaaaaaaaaigaabaaaaaaaaaaaefaaaaaj
pcaabaaaadaaaaaangafbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaa
efaaaaajpcaabaaaacaaaaaaigaabaaaacaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadcaaaaapdcaabaaaadaaaaaahgapbaaaadaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaa
apaaaaahbcaabaaaaaaaaaaaegaabaaaadaaaaaaegaabaaaadaaaaaaddaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaaibcaabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaa
adaaaaaaakaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaadaaaaaa
egbcbaaaadaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaaj
hcaabaaaabaaaaaaegbcbaaaadaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaahncaabaaaaaaaaaaaagaabaaaaaaaaaaaagbjbaaaadaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaadaaaaaaigadbaaaaaaaaaaabaaaaaahecaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaafecaabaaaaaaaaaaa
ckaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahecaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaa
deaaaaakfcaabaaaaaaaaaaaagacbaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaacpaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaadiaaaaah
ccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaafccaabaaa
aaaaaaaabkaabaaaaaaaaaaadiaaaaahccaabaaaaaaaaaaadkaabaaaacaaaaaa
bkaabaaaaaaaaaaadiaaaaajhcaabaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaa
egiccaaaaaaaaaaaacaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaa
agajbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaacaaaaaaegiccaaa
aaaaaaaaalaaaaaadiaaaaaiiccabaaaaaaaaaaadkaabaaaacaaaaaadkiacaaa
aaaaaaaaalaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaagaabaaa
aaaaaaaajgahbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaaeaaaaaa
egbcbaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaapgapbaaaaaaaaaaaeghobaaa
adaaaaaaaagabaaaaaaaaaaaaaaaaaahicaabaaaaaaaaaaaakaabaaaabaaaaaa
akaabaaaabaaaaaadiaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_PanPM]
Vector 6 [_RotPM]
Vector 7 [_Color]
Float 8 [_Shininess]
Float 9 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
"3.0-!!ARBfp1.0
# 85 ALU, 3 TEX
PARAM c[12] = { program.local[0..9],
		{ 0.0055555557, 1, 3.1415927, 0.5 },
		{ 0.41999999, 2, 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.x, c[6].w;
MAD R0.x, R0, c[10], c[10].y;
MOV R1.z, c[0].y;
MUL R0.x, R0, c[10].z;
MAD R0.x, R1.z, c[6].z, R0;
COS R0.y, R0.x;
SIN R0.z, R0.x;
ADD R0.x, fragment.texcoord[0].w, -c[6].y;
MUL R0.w, R0.x, R0.z;
MUL R1.x, R0.y, R0;
ADD R0.x, fragment.texcoord[0].z, -c[6];
MAD R0.z, R0.x, R0, R1.x;
MAD R0.x, R0, R0.y, -R0.w;
ADD R0.y, -R0.z, c[6];
ADD R0.x, -R0, c[6];
MAD R0.y, R1.z, c[5], R0;
MAD R0.x, R1.z, c[5], R0;
TEX R0.w, R0, texture[0], 2D;
DP3 R0.y, fragment.texcoord[1], fragment.texcoord[1];
MOV R0.x, c[9];
MUL R1.x, R0, c[10].w;
MAD R1.w, R0, c[9].x, -R1.x;
RSQ R3.y, R0.y;
MUL R0.xyz, R3.y, fragment.texcoord[1];
ADD R0.z, R0, c[11].x;
RCP R0.z, R0.z;
MUL R1.xy, R0, R0.z;
MAD R0.xy, R1.w, R1, fragment.texcoord[0].zwzw;
MAD R1.xy, R1.w, R1, fragment.texcoord[0];
MOV R0.w, c[4];
MAD R0.w, R0, c[10].x, c[10].y;
MUL R0.z, R0.w, c[10];
MAD R0.z, R1, c[4], R0;
MOV R2.xyz, fragment.texcoord[2];
SIN R3.x, R0.z;
ADD R1.y, R1, -c[4];
COS R2.w, R0.z;
MUL R1.w, R1.y, R3.x;
ADD R0.y, R0, -c[4];
MUL R0.z, R2.w, R0.y;
ADD R0.x, R0, -c[4];
MUL R0.y, R3.x, R0;
MAD R0.y, R2.w, R0.x, -R0;
MAD R0.z, R3.x, R0.x, R0;
ADD R0.x, -R0.y, c[4];
ADD R0.y, -R0.z, c[4];
MAD R0.x, R1.z, c[3], R0;
MAD R0.y, R1.z, c[3], R0;
TEX R0.yw, R0, texture[2], 2D;
MOV R0.z, c[10].y;
MAD R0.xy, R0.wyzw, c[11].y, -R0.z;
MUL R0.zw, R0.xyxy, R0.xyxy;
ADD_SAT R0.z, R0, R0.w;
MAD R2.xyz, R3.y, fragment.texcoord[1], R2;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
ADD R0.z, -R0, c[10].y;
RSQ R0.z, R0.z;
MUL R2.xyz, R0.w, R2;
RCP R0.z, R0.z;
DP3 R0.w, R0, R2;
MAX R2.x, R0.w, c[11].z;
MOV R0.w, c[11];
MUL R0.w, R0, c[8].x;
POW R0.w, R2.x, R0.w;
DP3 R0.x, R0, fragment.texcoord[2];
MAX R2.x, R0, c[11].z;
MOV R0.xyz, c[2];
ADD R1.x, R1, -c[4];
MUL R1.y, R2.w, R1;
MAD R1.y, R1.x, R3.x, R1;
MAD R1.x, R1, R2.w, -R1.w;
ADD R1.y, -R1, c[4];
ADD R1.x, -R1, c[4];
MAD R1.y, R1.z, c[3], R1;
MAD R1.x, R1.z, c[3], R1;
TEX R1, R1, texture[1], 2D;
MUL R0.w, R1, R0;
MUL R1, R1, c[7];
MUL R1.xyz, R1, c[1];
MUL R1.xyz, R1, R2.x;
MUL R0.xyz, R0, c[1];
MAD R0.xyz, R0, R0.w, R1;
MUL result.color.xyz, R0, c[11].y;
MOV result.color.w, R1;
END
# 85 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_PanPM]
Vector 6 [_RotPM]
Vector 7 [_Color]
Float 8 [_Shininess]
Float 9 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
"ps_3_0
; 109 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c10, 0.00555556, 1.00000000, 3.14159274, 0.50000000
def c11, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c12, 0.41999999, 2.00000000, -1.00000000, 0.00000000
def c13, 128.00000000, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
mov r0.x, c6.w
mad r0.x, r0, c10, c10.y
mov r0.y, c6.z
mul r0.x, r0, c10.z
mad r0.x, c0.y, r0.y, r0
mad r0.x, r0, c11, c11.y
frc r0.x, r0
mad r1.x, r0, c11.z, c11.w
sincos r0.xy, r1.x
add r0.w, v0, -c6.y
mul r0.z, r0.w, r0.x
mul r0.w, r0, r0.y
add r1.x, v0.z, -c6
mad r0.x, r1, r0, -r0.w
mad r0.y, r1.x, r0, r0.z
mov r0.z, c5.x
add r0.x, -r0, c6
mad r0.x, c0.y, r0.z, r0
mov_pp r0.z, c10.w
mov r0.w, c5.y
add r0.y, -r0, c6
mad r0.y, c0, r0.w, r0
texld r0.w, r0, s0
mul_pp r0.z, c9.x, r0
dp3_pp r0.y, v1, v1
mad_pp r1.w, r0, c9.x, -r0.z
mov r0.x, c4.w
mad r0.w, r0.x, c10.x, c10.y
rsq_pp r1.z, r0.y
mul_pp r0.xyz, r1.z, v1
mov r1.x, c4.z
mul r0.w, r0, c10.z
mad r0.w, c0.y, r1.x, r0
add r1.x, r0.z, c12
mad r0.z, r0.w, c11.x, c11.y
rcp r0.w, r1.x
mul r2.xy, r0, r0.w
mad r1.xy, r1.w, r2, v0.zwzw
frc r0.z, r0
mad r2.z, r0, c11, c11.w
sincos r0.xy, r2.z
add r0.z, r1.y, -c4.y
mul r0.w, r0.y, r0.z
add r1.x, r1, -c4
mul r0.z, r0.x, r0
mad r0.z, r0.y, r1.x, r0
mad r0.w, r0.x, r1.x, -r0
add r0.z, -r0, c4.y
mov r1.x, c3.y
mad r1.y, c0, r1.x, r0.z
add r0.z, -r0.w, c4.x
mov r0.w, c3.x
mad r1.x, c0.y, r0.w, r0.z
texld r3.yw, r1, s2
mad_pp r1.xy, r3.wyzw, c12.y, c12.z
mul_pp r0.zw, r1.xyxy, r1.xyxy
add_pp_sat r0.z, r0, r0.w
add_pp r0.w, -r0.z, c10.y
mov_pp r3.xyz, v2
mad_pp r3.xyz, r1.z, v1, r3
dp3_pp r0.z, r3, r3
rsq_pp r0.w, r0.w
rsq_pp r0.z, r0.z
mul_pp r3.xyz, r0.z, r3
rcp_pp r1.z, r0.w
dp3_pp r0.w, r1, r3
mov_pp r0.z, c8.x
mul_pp r0.z, c13.x, r0
max_pp r0.w, r0, c12
pow r3, r0.w, r0.z
mad r0.zw, r1.w, r2.xyxy, v0.xyxy
add r0.w, r0, -c4.y
mul r2.x, r0.w, r0.y
mul r0.w, r0, r0.x
add r0.z, r0, -c4.x
mad r0.y, r0.z, r0, r0.w
mad r0.z, r0, r0.x, -r2.x
add r0.x, -r0.y, c4.y
dp3_pp r1.x, r1, v2
mov r0.y, c3
mad r0.y, c0, r0, r0.x
add r0.x, -r0.z, c4
mov r0.z, c3.x
mad r0.x, c0.y, r0.z, r0
texld r0, r0, s1
mov r1.w, r3.x
mul r1.w, r0, r1
mul_pp r0, r0, c7
max_pp r2.x, r1, c12.w
mul_pp r1.xyz, r0, c1
mov_pp r0.xyz, c1
mul_pp r1.xyz, r1, r2.x
mul_pp r0.xyz, c2, r0
mad r0.xyz, r0, r1.w, r1
mul oC0.xyz, r0, c12.y
mov_pp oC0.w, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
ConstBuffer "$Globals" 176 // 136 used size, 12 vars
Vector 16 [_LightColor0] 4
Vector 32 [_SpecColor] 4
Vector 48 [_PanMT] 4
Vector 64 [_RotMT] 4
Vector 80 [_PanPM] 4
Vector 96 [_RotPM] 4
Vector 112 [_Color] 4
Float 128 [_Shininess]
Float 132 [_Parallax]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_ParallaxMap] 2D 2
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_BumpMap] 2D 1
// 58 instructions, 5 temp regs, 0 temp arrays:
// ALU 52 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedeojcfdeinjoglpjjhbjefgcekcgainjdabaaaaaacaajaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcdaaiaaaaeaaaaaaaamacaaaafjaaaaaeegiocaaa
aaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
afaaaaaadcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaagaaaaaaabeaaaaa
gballgdlabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaanlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaagaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaa
bcaabaaaabaaaaaaakaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaa
abaaaaaafgiecaiaebaaaaaaaaaaaaaaagaaaaaadiaaaaahjcaabaaaaaaaaaaa
agaabaaaaaaaaaaafgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaa
aaaaaaaaakaabaaaabaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaaj
dcaabaaaaaaaaaaaegaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaagaaaaaa
dcaaaaalccaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaabkiacaaaabaaaaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaa
afaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaa
aaaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadiaaaaal
dcaabaaaaaaaaaaabgifcaaaaaaaaaaaaiaaaaaaaceaaaaaaaaaaadpaaaaaaed
aaaaaaaaaaaaaaaadcaaaaalbcaabaaaaaaaaaaadkaabaaaaaaaaaaabkiacaaa
aaaaaaaaaiaaaaaaakaabaiaebaaaaaaaaaaaaaabaaaaaahecaabaaaaaaaaaaa
egbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaafecaabaaaaaaaaaaackaabaaa
aaaaaaaadiaaaaahdcaabaaaabaaaaaakgakbaaaaaaaaaaaegbabaaaacaaaaaa
dcaaaaajicaabaaaaaaaaaaackbabaaaacaaaaaackaabaaaaaaaaaaaabeaaaaa
dnaknhdodcaaaaajhcaabaaaacaaaaaaegbcbaaaacaaaaaakgakbaaaaaaaaaaa
egbcbaaaadaaaaaaaoaaaaahpcaabaaaabaaaaaabgabbaaaabaaaaaapgapbaaa
aaaaaaaadcaaaaajpcaabaaaabaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaa
bgblbaaaabaaaaaaaaaaaaajpcaabaaaabaaaaaaegaobaaaabaaaaaabgibcaia
ebaaaaaaaaaaaaaaaeaaaaaadcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaa
aeaaaaaaabeaaaaagballgdlabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaanlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaa
aaaaaaaaaeaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaah
bcaabaaaaaaaaaaabcaabaaaadaaaaaaakaabaaaaaaaaaaadiaaaaahpcaabaaa
aeaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakfcaabaaaaaaaaaaa
fgahbaaaabaaaaaaagaabaaaadaaaaaaagacbaiaebaaaaaaaeaaaaaadcaaaaaj
dcaabaaaabaaaaaaigaabaaaabaaaaaaagaabaaaadaaaaaangafbaaaaeaaaaaa
aaaaaaajdcaabaaaabaaaaaaegaabaiaebaaaaaaabaaaaaafgifcaaaaaaaaaaa
aeaaaaaadcaaaaalmcaabaaaabaaaaaafgifcaaaaaaaaaaaadaaaaaafgifcaaa
abaaaaaaaaaaaaaaagaebaaaabaaaaaaaaaaaaajfcaabaaaaaaaaaaaagacbaia
ebaaaaaaaaaaaaaaagiacaaaaaaaaaaaaeaaaaaadcaaaaaldcaabaaaabaaaaaa
agiacaaaaaaaaaaaadaaaaaafgifcaaaabaaaaaaaaaaaaaaigaabaaaaaaaaaaa
efaaaaajpcaabaaaadaaaaaangafbaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaigaabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaaaaaaaaadcaaaaapdcaabaaaadaaaaaahgapbaaaadaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaa
aaaaaaaaapaaaaahbcaabaaaaaaaaaaaegaabaaaadaaaaaaegaabaaaadaaaaaa
ddaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaai
bcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaaf
ecaabaaaadaaaaaaakaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaa
acaaaaaaegacbaaaacaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahncaabaaaaaaaaaaaagaabaaaaaaaaaaaagajbaaaacaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaadaaaaaaigadbaaaaaaaaaaabaaaaaahecaabaaa
aaaaaaaaegacbaaaadaaaaaaegbcbaaaadaaaaaadeaaaaakfcaabaaaaaaaaaaa
agacbaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacpaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaabkaabaaaaaaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahbcaabaaaaaaaaaaadkaabaaaabaaaaaaakaabaaaaaaaaaaadiaaaaaj
hcaabaaaacaaaaaaegiccaaaaaaaaaaaabaaaaaaegiccaaaaaaaaaaaacaaaaaa
diaaaaahlcaabaaaaaaaaaaaagaabaaaaaaaaaaaegaibaaaacaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaai
iccabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaaaaaaaaaaahaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaadcaaaaaj
hcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
aaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_PanPM]
Vector 6 [_RotPM]
Vector 7 [_Color]
Float 8 [_Shininess]
Float 9 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"3.0-!!ARBfp1.0
# 96 ALU, 5 TEX
PARAM c[12] = { program.local[0..9],
		{ 0.0055555557, 1, 3.1415927, 0.5 },
		{ 0.41999999, 2, 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.x, c[6].w;
MAD R0.x, R0, c[10], c[10].y;
MOV R2.w, c[0].y;
MUL R0.x, R0, c[10].z;
MAD R0.x, R2.w, c[6].z, R0;
COS R0.y, R0.x;
SIN R0.z, R0.x;
ADD R0.x, fragment.texcoord[0].w, -c[6].y;
MUL R0.w, R0.x, R0.z;
MUL R1.x, R0.y, R0;
ADD R0.x, fragment.texcoord[0].z, -c[6];
MAD R0.z, R0.x, R0, R1.x;
MAD R0.x, R0, R0.y, -R0.w;
ADD R0.y, -R0.z, c[6];
ADD R0.x, -R0, c[6];
MOV R0.z, c[4].w;
MAD R0.y, R2.w, c[5], R0;
MAD R0.x, R2.w, c[5], R0;
TEX R0.w, R0, texture[0], 2D;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MOV R0.y, c[9].x;
MUL R0.y, R0, c[10].w;
MUL R1.xyz, R0.x, fragment.texcoord[1];
MAD R0.w, R0, c[9].x, -R0.y;
ADD R0.y, R1.z, c[11].x;
RCP R0.y, R0.y;
MUL R3.xy, R1, R0.y;
MAD R0.z, R0, c[10].x, c[10].y;
MUL R0.y, R0.z, c[10].z;
MAD R0.y, R2.w, c[4].z, R0;
MAD R1.xy, R0.w, R3, fragment.texcoord[0].zwzw;
COS R3.z, R0.y;
SIN R3.w, R0.y;
ADD R0.z, R1.y, -c[4].y;
MUL R1.y, R3.w, R0.z;
ADD R0.y, R1.x, -c[4].x;
MUL R0.z, R3, R0;
MAD R0.z, R3.w, R0.y, R0;
MAD R0.y, R3.z, R0, -R1;
ADD R0.z, -R0, c[4].y;
MAD R1.y, R2.w, c[3], R0.z;
ADD R0.y, -R0, c[4].x;
MAD R1.x, R2.w, c[3], R0.y;
DP3 R0.z, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.z, R0.z;
MUL R2.xyz, R0.z, fragment.texcoord[2];
TEX R1.yw, R1, texture[2], 2D;
MOV R0.y, c[10];
MAD R1.xy, R1.wyzw, c[11].y, -R0.y;
MUL R1.zw, R1.xyxy, R1.xyxy;
ADD_SAT R1.z, R1, R1.w;
MAD R0.xyz, R0.x, fragment.texcoord[1], R2;
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
ADD R1.z, -R1, c[10].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R0.x, R1, R0;
MAX R0.z, R0.x, c[11];
MAD R0.xy, R0.w, R3, fragment.texcoord[0];
MOV R1.w, c[11];
MUL R0.w, R1, c[8].x;
POW R1.w, R0.z, R0.w;
ADD R0.y, R0, -c[4];
MUL R0.z, R0.y, R3.w;
DP3 R1.x, R1, R2;
MUL R0.y, R3.z, R0;
ADD R0.x, R0, -c[4];
MAD R0.y, R0.x, R3.w, R0;
MAD R0.x, R0, R3.z, -R0.z;
ADD R0.y, -R0, c[4];
ADD R0.x, -R0, c[4];
MAD R0.y, R2.w, c[3], R0;
MAD R0.x, R2.w, c[3], R0;
TEX R0, R0, texture[1], 2D;
MUL R3, R0, c[7];
MUL R2.w, R0, R1;
DP3 R1.w, fragment.texcoord[3], fragment.texcoord[3];
MAX R0.w, R1.x, c[11].z;
MUL R0.xyz, R3, c[1];
MUL R1.xyz, R0, R0.w;
RCP R0.w, fragment.texcoord[3].w;
MAD R2.xy, fragment.texcoord[3], R0.w, c[10].w;
TEX R0.w, R2, texture[3], 2D;
MOV R0.xyz, c[2];
SLT R2.x, c[11].z, fragment.texcoord[3].z;
MUL R0.xyz, R0, c[1];
TEX R1.w, R1.w, texture[4], 2D;
MUL R0.w, R2.x, R0;
MUL R0.w, R0, R1;
MUL R0.w, R0, c[11].y;
MAD R0.xyz, R0, R2.w, R1;
MUL result.color.xyz, R0, R0.w;
MOV result.color.w, R3;
END
# 96 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_PanPM]
Vector 6 [_RotPM]
Vector 7 [_Color]
Float 8 [_Shininess]
Float 9 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"ps_3_0
; 118 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c10, 0.00555556, 1.00000000, 3.14159274, 0.50000000
def c11, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c12, 0.41999999, 2.00000000, -1.00000000, 0.00000000
def c13, 128.00000000, 0.00000000, 1.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
mov r0.x, c6.w
mad r0.x, r0, c10, c10.y
mul r0.y, r0.x, c10.z
mov r0.x, c6.z
mad r0.x, c0.y, r0, r0.y
mad r0.x, r0, c11, c11.y
frc r0.x, r0
mad r1.x, r0, c11.z, c11.w
sincos r0.xy, r1.x
add r0.z, v0.w, -c6.y
mul r1.x, r0.z, r0
mul r0.w, r0.z, r0.y
add r0.z, v0, -c6.x
mad r0.x, r0.z, r0, -r0.w
mad r0.z, r0, r0.y, r1.x
add r0.y, -r0.x, c6.x
add r0.w, -r0.z, c6.y
mov r0.x, c5
mad r0.x, c0.y, r0, r0.y
mov_pp r0.z, c10.w
mov r0.y, c5
mad r0.y, c0, r0, r0.w
texld r0.w, r0, s0
mul_pp r0.z, c9.x, r0
mad_pp r1.w, r0, c9.x, -r0.z
dp3_pp r0.x, v1, v1
rsq_pp r0.z, r0.x
mov r0.y, c4.w
mad r0.x, r0.y, c10, c10.y
mul r0.y, r0.x, c10.z
mov r0.x, c4.z
mad r0.y, c0, r0.x, r0
mul_pp r1.xyz, r0.z, v1
add r0.x, r1.z, c12
rcp r0.x, r0.x
mad r0.y, r0, c11.x, c11
frc r0.y, r0
mad r0.w, r0.y, c11.z, c11
mul r4.xy, r1, r0.x
mad r0.xy, r1.w, r4, v0.zwzw
sincos r3.xy, r0.w
add r0.y, r0, -c4
mul r0.w, r3.y, r0.y
add r0.x, r0, -c4
mad r0.w, r3.x, r0.x, -r0
mul r0.y, r3.x, r0
mad r0.y, r3, r0.x, r0
mov r0.x, c3.y
add r0.y, -r0, c4
mad r0.y, c0, r0.x, r0
add r0.w, -r0, c4.x
mov r0.x, c3
mad r0.x, c0.y, r0, r0.w
texld r0.yw, r0, s2
mad_pp r1.xy, r0.wyzw, c12.y, c12.z
dp3_pp r0.x, v2, v2
rsq_pp r0.w, r0.x
mul_pp r0.xy, r1, r1
mul_pp r2.xyz, r0.w, v2
add_pp_sat r0.w, r0.x, r0.y
mad_pp r0.xyz, r0.z, v1, r2
dp3_pp r1.z, r0, r0
rsq_pp r2.w, r1.z
add_pp r0.w, -r0, c10.y
rsq_pp r0.w, r0.w
rcp_pp r1.z, r0.w
mul_pp r0.xyz, r2.w, r0
dp3_pp r0.x, r1, r0
mov_pp r0.w, c8.x
dp3_pp r1.x, r1, r2
max_pp r2.w, r0.x, c12
mul_pp r3.z, c13.x, r0.w
pow r0, r2.w, r3.z
mad r0.zw, r1.w, r4.xyxy, v0.xyxy
add r0.y, r0.w, -c4
mul r0.w, r0.y, r3.y
mov r1.w, r0.x
add r0.x, r0.z, -c4
mad r0.z, r0.x, r3.x, -r0.w
mul r0.y, r0, r3.x
mad r0.y, r0.x, r3, r0
mov r0.x, c3.y
add r0.y, -r0, c4
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c4.x
mov r0.x, c3
mad r0.x, c0.y, r0, r0.z
texld r0, r0, s1
mul_pp r2, r0, c7
mul r1.w, r0, r1
max_pp r0.w, r1.x, c12
mul_pp r0.xyz, r2, c1
mul_pp r2.xyz, r0, r0.w
rcp r0.x, v3.w
mad r3.xy, v3, r0.x, c10.w
dp3 r0.x, v3, v3
texld r0.w, r3, s3
cmp r0.y, -v3.z, c13, c13.z
mul_pp r0.y, r0, r0.w
texld r0.x, r0.x, s4
mul_pp r0.w, r0.y, r0.x
mov_pp r1.xyz, c1
mul_pp r0.xyz, c2, r1
mul_pp r0.w, r0, c12.y
mad r0.xyz, r0, r1.w, r2
mul oC0.xyz, r0, r0.w
mov_pp oC0.w, r2
"
}

SubProgram "d3d11 " {
Keywords { "SPOT" }
ConstBuffer "$Globals" 240 // 200 used size, 13 vars
Vector 16 [_LightColor0] 4
Vector 32 [_SpecColor] 4
Vector 112 [_PanMT] 4
Vector 128 [_RotMT] 4
Vector 144 [_PanPM] 4
Vector 160 [_RotPM] 4
Vector 176 [_Color] 4
Float 192 [_Shininess]
Float 196 [_Parallax]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_ParallaxMap] 2D 4
SetTexture 1 [_MainTex] 2D 2
SetTexture 2 [_BumpMap] 2D 3
SetTexture 3 [_LightTexture0] 2D 0
SetTexture 4 [_LightTextureB0] 2D 1
// 70 instructions, 5 temp regs, 0 temp arrays:
// ALU 61 float, 0 int, 1 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedcidkgabbgnfahggglnjdpjmlgjdpoiieabaaaaaaoaakaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcniajaaaaeaaaaaaahgacaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaa
dcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaakaaaaaaabeaaaaagballgdl
abeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
nlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaakaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaabcaabaaa
abaaaaaaakaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaaabaaaaaa
fgiecaiaebaaaaaaaaaaaaaaakaaaaaadiaaaaahjcaabaaaaaaaaaaaagaabaaa
aaaaaaaafgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaaaaaaaaaa
akaabaaaabaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaajdcaabaaa
aaaaaaaaegaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaakaaaaaadcaaaaal
ccaabaaaabaaaaaabkiacaaaaaaaaaaaajaaaaaabkiacaaaabaaaaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaajaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaeaaaaaadiaaaaaldcaabaaa
aaaaaaaabgifcaaaaaaaaaaaamaaaaaaaceaaaaaaaaaaadpaaaaaaedaaaaaaaa
aaaaaaaadcaaaaalbcaabaaaaaaaaaaadkaabaaaaaaaaaaabkiacaaaaaaaaaaa
amaaaaaaakaabaiaebaaaaaaaaaaaaaabaaaaaahecaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaa
dcaaaaajicaabaaaaaaaaaaackbabaaaacaaaaaackaabaaaaaaaaaaaabeaaaaa
dnaknhdodiaaaaahhcaabaaaabaaaaaakgakbaaaaaaaaaaaegbcbaaaacaaaaaa
aoaaaaahpcaabaaaacaaaaaabgabbaaaabaaaaaapgapbaaaaaaaaaaadcaaaaaj
pcaabaaaacaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaabgblbaaaabaaaaaa
aaaaaaajpcaabaaaacaaaaaaegaobaaaacaaaaaabgibcaiaebaaaaaaaaaaaaaa
aiaaaaaadcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaaiaaaaaaabeaaaaa
gballgdlabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaanlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaaiaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaa
bcaabaaaadaaaaaaakaabaaaaaaaaaaadiaaaaahpcaabaaaaeaaaaaaagaabaaa
aaaaaaaaegaobaaaacaaaaaadcaaaaakfcaabaaaaaaaaaaafgahbaaaacaaaaaa
agaabaaaadaaaaaaagacbaiaebaaaaaaaeaaaaaadcaaaaajdcaabaaaacaaaaaa
igaabaaaacaaaaaaagaabaaaadaaaaaangafbaaaaeaaaaaaaaaaaaajdcaabaaa
acaaaaaaegaabaiaebaaaaaaacaaaaaafgifcaaaaaaaaaaaaiaaaaaadcaaaaal
mcaabaaaacaaaaaafgifcaaaaaaaaaaaahaaaaaafgifcaaaabaaaaaaaaaaaaaa
agaebaaaacaaaaaaaaaaaaajfcaabaaaaaaaaaaaagacbaiaebaaaaaaaaaaaaaa
agiacaaaaaaaaaaaaiaaaaaadcaaaaaldcaabaaaacaaaaaaagiacaaaaaaaaaaa
ahaaaaaafgifcaaaabaaaaaaaaaaaaaaigaabaaaaaaaaaaaefaaaaajpcaabaaa
adaaaaaangafbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaaefaaaaaj
pcaabaaaacaaaaaaigaabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaa
dcaaaaapdcaabaaaadaaaaaahgapbaaaadaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaah
bcaabaaaaaaaaaaaegaabaaaadaaaaaaegaabaaaadaaaaaaddaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaaibcaabaaaaaaaaaaa
akaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaaadaaaaaa
akaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaa
adaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaajhcaabaaa
abaaaaaaegbcbaaaadaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadiaaaaah
ncaabaaaaaaaaaaaagaabaaaaaaaaaaaagbjbaaaadaaaaaabaaaaaahbcaabaaa
aaaaaaaaegacbaaaadaaaaaaigadbaaaaaaaaaaabaaaaaahecaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaafecaabaaaaaaaaaaackaabaaa
aaaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahecaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaadeaaaaak
fcaabaaaaaaaaaaaagacbaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaacpaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaadiaaaaahccaabaaa
aaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaafccaabaaaaaaaaaaa
bkaabaaaaaaaaaaadiaaaaahccaabaaaaaaaaaaadkaabaaaacaaaaaabkaabaaa
aaaaaaaadiaaaaajhcaabaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaaegiccaaa
aaaaaaaaacaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaa
alaaaaaadiaaaaaiiccabaaaaaaaaaaadkaabaaaacaaaaaadkiacaaaaaaaaaaa
alaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
abaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaagaabaaaaaaaaaaa
jgahbaaaaaaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaaaeaaaaaapgbpbaaa
aeaaaaaaaaaaaaakdcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaaaaaaaaadbaaaaahicaabaaaaaaaaaaaabeaaaaa
aaaaaaaackbabaaaaeaaaaaaabaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaaabaaaaaadkaabaaa
aaaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaaeaaaaaaegbcbaaaaeaaaaaa
efaaaaajpcaabaaaabaaaaaaagaabaaaabaaaaaaeghobaaaaeaaaaaaaagabaaa
abaaaaaaapaaaaahicaabaaaaaaaaaaapgapbaaaaaaaaaaaagaabaaaabaaaaaa
diaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_PanPM]
Vector 6 [_RotPM]
Vector 7 [_Color]
Float 8 [_Shininess]
Float 9 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"3.0-!!ARBfp1.0
# 92 ALU, 5 TEX
PARAM c[12] = { program.local[0..9],
		{ 0.0055555557, 1, 3.1415927, 0.5 },
		{ 0.41999999, 2, 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.x, c[6].w;
MAD R0.x, R0, c[10], c[10].y;
MOV R2.w, c[0].y;
MUL R0.x, R0, c[10].z;
MAD R0.x, R2.w, c[6].z, R0;
COS R0.y, R0.x;
SIN R0.z, R0.x;
ADD R0.x, fragment.texcoord[0].w, -c[6].y;
MUL R0.w, R0.x, R0.z;
MUL R1.x, R0.y, R0;
ADD R0.x, fragment.texcoord[0].z, -c[6];
MAD R0.z, R0.x, R0, R1.x;
MAD R0.x, R0, R0.y, -R0.w;
ADD R0.y, -R0.z, c[6];
ADD R0.x, -R0, c[6];
MOV R0.z, c[4].w;
MAD R0.y, R2.w, c[5], R0;
MAD R0.x, R2.w, c[5], R0;
TEX R0.w, R0, texture[0], 2D;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MOV R0.y, c[9].x;
MUL R0.y, R0, c[10].w;
MUL R1.xyz, R0.x, fragment.texcoord[1];
MAD R0.w, R0, c[9].x, -R0.y;
ADD R0.y, R1.z, c[11].x;
RCP R0.y, R0.y;
MUL R3.xy, R1, R0.y;
MAD R0.z, R0, c[10].x, c[10].y;
MUL R0.y, R0.z, c[10].z;
MAD R0.y, R2.w, c[4].z, R0;
MAD R1.xy, R0.w, R3, fragment.texcoord[0].zwzw;
COS R3.z, R0.y;
SIN R3.w, R0.y;
ADD R0.z, R1.y, -c[4].y;
MUL R1.y, R3.w, R0.z;
ADD R0.y, R1.x, -c[4].x;
MUL R0.z, R3, R0;
MAD R0.z, R3.w, R0.y, R0;
MAD R0.y, R3.z, R0, -R1;
ADD R0.z, -R0, c[4].y;
MAD R1.y, R2.w, c[3], R0.z;
ADD R0.y, -R0, c[4].x;
MAD R1.x, R2.w, c[3], R0.y;
DP3 R0.z, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.z, R0.z;
TEX R1.yw, R1, texture[2], 2D;
MOV R0.y, c[10];
MAD R1.xy, R1.wyzw, c[11].y, -R0.y;
MUL R1.zw, R1.xyxy, R1.xyxy;
MUL R2.xyz, R0.z, fragment.texcoord[2];
ADD_SAT R1.z, R1, R1.w;
MAD R0.xyz, R0.x, fragment.texcoord[1], R2;
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
ADD R1.z, -R1, c[10].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R0.x, R1, R0;
MAX R0.z, R0.x, c[11];
MAD R0.xy, R0.w, R3, fragment.texcoord[0];
MOV R1.w, c[11];
MUL R0.w, R1, c[8].x;
POW R1.w, R0.z, R0.w;
ADD R0.y, R0, -c[4];
MUL R0.z, R0.y, R3.w;
MUL R0.y, R3.z, R0;
ADD R0.x, R0, -c[4];
MAD R0.y, R0.x, R3.w, R0;
MAD R0.x, R0, R3.z, -R0.z;
ADD R0.y, -R0, c[4];
ADD R0.x, -R0, c[4];
MAD R0.y, R2.w, c[3], R0;
MAD R0.x, R2.w, c[3], R0;
TEX R0, R0, texture[1], 2D;
MUL R3, R0, c[7];
MUL R2.w, R0, R1;
DP3 R1.x, R1, R2;
DP3 R1.w, fragment.texcoord[3], fragment.texcoord[3];
MAX R0.w, R1.x, c[11].z;
MUL R0.xyz, R3, c[1];
MUL R1.xyz, R0, R0.w;
MOV R0.xyz, c[2];
MUL R0.xyz, R0, c[1];
TEX R0.w, fragment.texcoord[3], texture[4], CUBE;
TEX R1.w, R1.w, texture[3], 2D;
MUL R0.w, R1, R0;
MUL R0.w, R0, c[11].y;
MAD R0.xyz, R0, R2.w, R1;
MUL result.color.xyz, R0, R0.w;
MOV result.color.w, R3;
END
# 92 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_PanPM]
Vector 6 [_RotPM]
Vector 7 [_Color]
Float 8 [_Shininess]
Float 9 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"ps_3_0
; 114 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c10, 0.00555556, 1.00000000, 3.14159274, 0.50000000
def c11, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c12, 0.41999999, 2.00000000, -1.00000000, 0.00000000
def c13, 128.00000000, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
mov r0.x, c6.w
mad r0.x, r0, c10, c10.y
mul r0.y, r0.x, c10.z
mov r0.x, c6.z
mad r0.x, c0.y, r0, r0.y
mad r0.x, r0, c11, c11.y
frc r0.x, r0
mad r1.x, r0, c11.z, c11.w
sincos r0.xy, r1.x
add r0.z, v0.w, -c6.y
mul r1.x, r0.z, r0
mul r0.w, r0.z, r0.y
add r0.z, v0, -c6.x
mad r0.x, r0.z, r0, -r0.w
mad r0.z, r0, r0.y, r1.x
add r0.y, -r0.x, c6.x
add r0.w, -r0.z, c6.y
mov r0.x, c5
mad r0.x, c0.y, r0, r0.y
mov_pp r0.z, c10.w
mov r0.y, c5
mad r0.y, c0, r0, r0.w
texld r0.w, r0, s0
mul_pp r0.z, c9.x, r0
mad_pp r1.w, r0, c9.x, -r0.z
dp3_pp r0.x, v1, v1
rsq_pp r0.z, r0.x
mov r0.y, c4.w
mad r0.x, r0.y, c10, c10.y
mul r0.y, r0.x, c10.z
mov r0.x, c4.z
mad r0.y, c0, r0.x, r0
mul_pp r1.xyz, r0.z, v1
add r0.x, r1.z, c12
rcp r0.x, r0.x
mad r0.y, r0, c11.x, c11
frc r0.y, r0
mad r0.w, r0.y, c11.z, c11
mul r4.xy, r1, r0.x
mad r0.xy, r1.w, r4, v0.zwzw
sincos r3.xy, r0.w
add r0.y, r0, -c4
mul r0.w, r3.y, r0.y
add r0.x, r0, -c4
mad r0.w, r3.x, r0.x, -r0
mul r0.y, r3.x, r0
mad r0.y, r3, r0.x, r0
mov r0.x, c3.y
add r0.y, -r0, c4
mad r0.y, c0, r0.x, r0
add r0.w, -r0, c4.x
mov r0.x, c3
mad r0.x, c0.y, r0, r0.w
texld r0.yw, r0, s2
mad_pp r1.xy, r0.wyzw, c12.y, c12.z
dp3_pp r0.x, v2, v2
rsq_pp r0.w, r0.x
mul_pp r0.xy, r1, r1
mul_pp r2.xyz, r0.w, v2
add_pp_sat r0.w, r0.x, r0.y
mad_pp r0.xyz, r0.z, v1, r2
dp3_pp r1.z, r0, r0
rsq_pp r2.w, r1.z
add_pp r0.w, -r0, c10.y
rsq_pp r0.w, r0.w
rcp_pp r1.z, r0.w
mul_pp r0.xyz, r2.w, r0
dp3_pp r0.x, r1, r0
mov_pp r0.w, c8.x
dp3_pp r1.x, r1, r2
max_pp r2.w, r0.x, c12
mul_pp r3.z, c13.x, r0.w
pow r0, r2.w, r3.z
mad r0.zw, r1.w, r4.xyxy, v0.xyxy
add r0.y, r0.w, -c4
mul r0.w, r0.y, r3.y
mov r1.w, r0.x
add r0.x, r0.z, -c4
mad r0.z, r0.x, r3.x, -r0.w
mul r0.y, r0, r3.x
mad r0.y, r0.x, r3, r0
mov r0.x, c3.y
add r0.y, -r0, c4
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c4.x
mov r0.x, c3
mad r0.x, c0.y, r0, r0.z
texld r0, r0, s1
mul_pp r2, r0, c7
mul r1.w, r0, r1
max_pp r0.w, r1.x, c12
mul_pp r0.xyz, r2, c1
mul_pp r2.xyz, r0, r0.w
dp3 r0.x, v3, v3
texld r0.x, r0.x, s3
texld r0.w, v3, s4
mul r0.w, r0.x, r0
mov_pp r1.xyz, c1
mul_pp r0.xyz, c2, r1
mul_pp r0.w, r0, c12.y
mad r0.xyz, r0, r1.w, r2
mul oC0.xyz, r0, r0.w
mov_pp oC0.w, r2
"
}

SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
ConstBuffer "$Globals" 240 // 200 used size, 13 vars
Vector 16 [_LightColor0] 4
Vector 32 [_SpecColor] 4
Vector 112 [_PanMT] 4
Vector 128 [_RotMT] 4
Vector 144 [_PanPM] 4
Vector 160 [_RotPM] 4
Vector 176 [_Color] 4
Float 192 [_Shininess]
Float 196 [_Parallax]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_ParallaxMap] 2D 4
SetTexture 1 [_MainTex] 2D 2
SetTexture 2 [_BumpMap] 2D 3
SetTexture 3 [_LightTextureB0] 2D 1
SetTexture 4 [_LightTexture0] CUBE 0
// 65 instructions, 5 temp regs, 0 temp arrays:
// ALU 57 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedpaadniafjdlobempifajmkjmfncfkjmiabaaaaaaeiakaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefceaajaaaaeaaaaaaafaacaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafidaaaaeaahabaaaaeaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaa
dcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaakaaaaaaabeaaaaagballgdl
abeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
nlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaakaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaabcaabaaa
abaaaaaaakaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaaabaaaaaa
fgiecaiaebaaaaaaaaaaaaaaakaaaaaadiaaaaahjcaabaaaaaaaaaaaagaabaaa
aaaaaaaafgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaaaaaaaaaa
akaabaaaabaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaajdcaabaaa
aaaaaaaaegaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaakaaaaaadcaaaaal
ccaabaaaabaaaaaabkiacaaaaaaaaaaaajaaaaaabkiacaaaabaaaaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaajaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaeaaaaaadiaaaaaldcaabaaa
aaaaaaaabgifcaaaaaaaaaaaamaaaaaaaceaaaaaaaaaaadpaaaaaaedaaaaaaaa
aaaaaaaadcaaaaalbcaabaaaaaaaaaaadkaabaaaaaaaaaaabkiacaaaaaaaaaaa
amaaaaaaakaabaiaebaaaaaaaaaaaaaabaaaaaahecaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaa
dcaaaaajicaabaaaaaaaaaaackbabaaaacaaaaaackaabaaaaaaaaaaaabeaaaaa
dnaknhdodiaaaaahhcaabaaaabaaaaaakgakbaaaaaaaaaaaegbcbaaaacaaaaaa
aoaaaaahpcaabaaaacaaaaaabgabbaaaabaaaaaapgapbaaaaaaaaaaadcaaaaaj
pcaabaaaacaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaabgblbaaaabaaaaaa
aaaaaaajpcaabaaaacaaaaaaegaobaaaacaaaaaabgibcaiaebaaaaaaaaaaaaaa
aiaaaaaadcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaaiaaaaaaabeaaaaa
gballgdlabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaanlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaaiaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaa
bcaabaaaadaaaaaaakaabaaaaaaaaaaadiaaaaahpcaabaaaaeaaaaaaagaabaaa
aaaaaaaaegaobaaaacaaaaaadcaaaaakfcaabaaaaaaaaaaafgahbaaaacaaaaaa
agaabaaaadaaaaaaagacbaiaebaaaaaaaeaaaaaadcaaaaajdcaabaaaacaaaaaa
igaabaaaacaaaaaaagaabaaaadaaaaaangafbaaaaeaaaaaaaaaaaaajdcaabaaa
acaaaaaaegaabaiaebaaaaaaacaaaaaafgifcaaaaaaaaaaaaiaaaaaadcaaaaal
mcaabaaaacaaaaaafgifcaaaaaaaaaaaahaaaaaafgifcaaaabaaaaaaaaaaaaaa
agaebaaaacaaaaaaaaaaaaajfcaabaaaaaaaaaaaagacbaiaebaaaaaaaaaaaaaa
agiacaaaaaaaaaaaaiaaaaaadcaaaaaldcaabaaaacaaaaaaagiacaaaaaaaaaaa
ahaaaaaafgifcaaaabaaaaaaaaaaaaaaigaabaaaaaaaaaaaefaaaaajpcaabaaa
adaaaaaangafbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaaefaaaaaj
pcaabaaaacaaaaaaigaabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaa
dcaaaaapdcaabaaaadaaaaaahgapbaaaadaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaah
bcaabaaaaaaaaaaaegaabaaaadaaaaaaegaabaaaadaaaaaaddaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaaibcaabaaaaaaaaaaa
akaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaaadaaaaaa
akaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaa
adaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaajhcaabaaa
abaaaaaaegbcbaaaadaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadiaaaaah
ncaabaaaaaaaaaaaagaabaaaaaaaaaaaagbjbaaaadaaaaaabaaaaaahbcaabaaa
aaaaaaaaegacbaaaadaaaaaaigadbaaaaaaaaaaabaaaaaahecaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaafecaabaaaaaaaaaaackaabaaa
aaaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahecaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaadeaaaaak
fcaabaaaaaaaaaaaagacbaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaacpaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaadiaaaaahccaabaaa
aaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaafccaabaaaaaaaaaaa
bkaabaaaaaaaaaaadiaaaaahccaabaaaaaaaaaaadkaabaaaacaaaaaabkaabaaa
aaaaaaaadiaaaaajhcaabaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaaegiccaaa
aaaaaaaaacaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaa
alaaaaaadiaaaaaiiccabaaaaaaaaaaadkaabaaaacaaaaaadkiacaaaaaaaaaaa
alaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
abaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaagaabaaaaaaaaaaa
jgahbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaaeaaaaaaegbcbaaa
aeaaaaaaefaaaaajpcaabaaaabaaaaaapgapbaaaaaaaaaaaeghobaaaadaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbcbaaaaeaaaaaaeghobaaa
aeaaaaaaaagabaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaaagaabaaaabaaaaaa
pgapbaaaacaaaaaadiaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_PanPM]
Vector 6 [_RotPM]
Vector 7 [_Color]
Float 8 [_Shininess]
Float 9 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"3.0-!!ARBfp1.0
# 87 ALU, 4 TEX
PARAM c[12] = { program.local[0..9],
		{ 0.0055555557, 1, 3.1415927, 0.5 },
		{ 0.41999999, 2, 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.x, c[6].w;
MAD R0.x, R0, c[10], c[10].y;
MOV R1.z, c[0].y;
MUL R0.x, R0, c[10].z;
MAD R0.x, R1.z, c[6].z, R0;
COS R0.y, R0.x;
SIN R0.z, R0.x;
ADD R0.x, fragment.texcoord[0].w, -c[6].y;
MUL R0.w, R0.x, R0.z;
MUL R1.x, R0.y, R0;
ADD R0.x, fragment.texcoord[0].z, -c[6];
MAD R0.z, R0.x, R0, R1.x;
MAD R0.x, R0, R0.y, -R0.w;
ADD R0.y, -R0.z, c[6];
ADD R0.x, -R0, c[6];
MAD R0.y, R1.z, c[5], R0;
MAD R0.x, R1.z, c[5], R0;
TEX R0.w, R0, texture[0], 2D;
DP3 R0.y, fragment.texcoord[1], fragment.texcoord[1];
MOV R0.x, c[9];
MUL R1.x, R0, c[10].w;
MAD R1.w, R0, c[9].x, -R1.x;
RSQ R3.y, R0.y;
MUL R0.xyz, R3.y, fragment.texcoord[1];
ADD R0.z, R0, c[11].x;
RCP R0.z, R0.z;
MUL R1.xy, R0, R0.z;
MAD R0.xy, R1.w, R1, fragment.texcoord[0].zwzw;
MAD R1.xy, R1.w, R1, fragment.texcoord[0];
MOV R0.w, c[4];
MAD R0.w, R0, c[10].x, c[10].y;
MUL R0.z, R0.w, c[10];
MAD R0.z, R1, c[4], R0;
MOV R2.xyz, fragment.texcoord[2];
SIN R3.x, R0.z;
ADD R1.y, R1, -c[4];
COS R2.w, R0.z;
MUL R1.w, R1.y, R3.x;
ADD R0.y, R0, -c[4];
MUL R0.z, R2.w, R0.y;
ADD R0.x, R0, -c[4];
MUL R0.y, R3.x, R0;
MAD R0.y, R2.w, R0.x, -R0;
MAD R0.z, R3.x, R0.x, R0;
ADD R0.x, -R0.y, c[4];
ADD R0.y, -R0.z, c[4];
MAD R0.x, R1.z, c[3], R0;
MAD R0.y, R1.z, c[3], R0;
TEX R0.yw, R0, texture[2], 2D;
MOV R0.z, c[10].y;
MAD R0.xy, R0.wyzw, c[11].y, -R0.z;
MUL R0.zw, R0.xyxy, R0.xyxy;
ADD_SAT R0.z, R0, R0.w;
MAD R2.xyz, R3.y, fragment.texcoord[1], R2;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
ADD R0.z, -R0, c[10].y;
RSQ R0.z, R0.z;
MUL R2.xyz, R0.w, R2;
RCP R0.z, R0.z;
DP3 R0.w, R0, R2;
MAX R2.x, R0.w, c[11].z;
MOV R0.w, c[11];
MUL R0.w, R0, c[8].x;
POW R0.w, R2.x, R0.w;
ADD R1.x, R1, -c[4];
MUL R1.y, R2.w, R1;
MAD R1.y, R1.x, R3.x, R1;
MAD R1.x, R1, R2.w, -R1.w;
ADD R1.y, -R1, c[4];
ADD R1.x, -R1, c[4];
DP3 R0.x, R0, fragment.texcoord[2];
MAD R1.y, R1.z, c[3], R1;
MAD R1.x, R1.z, c[3], R1;
TEX R1, R1, texture[1], 2D;
MUL R2.x, R1.w, R0.w;
MUL R1, R1, c[7];
MAX R0.w, R0.x, c[11].z;
MUL R0.xyz, R1, c[1];
MUL R0.xyz, R0, R0.w;
MOV R1.xyz, c[2];
TEX R0.w, fragment.texcoord[3], texture[3], 2D;
MUL R1.xyz, R1, c[1];
MUL R0.w, R0, c[11].y;
MAD R0.xyz, R1, R2.x, R0;
MUL result.color.xyz, R0, R0.w;
MOV result.color.w, R1;
END
# 87 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_PanPM]
Vector 6 [_RotPM]
Vector 7 [_Color]
Float 8 [_Shininess]
Float 9 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_3_0
; 110 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c10, 0.00555556, 1.00000000, 3.14159274, 0.50000000
def c11, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c12, 0.41999999, 2.00000000, -1.00000000, 0.00000000
def c13, 128.00000000, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
mov r0.x, c6.w
mad r0.x, r0, c10, c10.y
mov r0.y, c6.z
mul r0.x, r0, c10.z
mad r0.x, c0.y, r0.y, r0
mad r0.x, r0, c11, c11.y
frc r0.x, r0
mad r1.x, r0, c11.z, c11.w
sincos r0.xy, r1.x
add r0.w, v0, -c6.y
mul r0.z, r0.w, r0.x
mul r0.w, r0, r0.y
add r1.x, v0.z, -c6
mad r0.x, r1, r0, -r0.w
mad r0.y, r1.x, r0, r0.z
mov r0.z, c5.x
add r0.x, -r0, c6
mad r0.x, c0.y, r0.z, r0
mov_pp r0.z, c10.w
mov r0.w, c5.y
add r0.y, -r0, c6
mad r0.y, c0, r0.w, r0
texld r0.w, r0, s0
mul_pp r0.z, c9.x, r0
dp3_pp r0.y, v1, v1
mad_pp r1.w, r0, c9.x, -r0.z
mov r0.x, c4.w
mad r0.w, r0.x, c10.x, c10.y
rsq_pp r1.z, r0.y
mul_pp r0.xyz, r1.z, v1
mov r1.x, c4.z
mul r0.w, r0, c10.z
mad r0.w, c0.y, r1.x, r0
add r1.x, r0.z, c12
mad r0.z, r0.w, c11.x, c11.y
rcp r0.w, r1.x
mul r2.xy, r0, r0.w
mad r1.xy, r1.w, r2, v0.zwzw
frc r0.z, r0
mad r2.z, r0, c11, c11.w
sincos r0.xy, r2.z
add r0.z, r1.y, -c4.y
mul r0.w, r0.y, r0.z
add r1.x, r1, -c4
mul r0.z, r0.x, r0
mad r0.z, r0.y, r1.x, r0
mad r0.w, r0.x, r1.x, -r0
add r0.z, -r0, c4.y
mov r1.x, c3.y
mad r1.y, c0, r1.x, r0.z
add r0.z, -r0.w, c4.x
mov r0.w, c3.x
mad r1.x, c0.y, r0.w, r0.z
texld r3.yw, r1, s2
mad_pp r1.xy, r3.wyzw, c12.y, c12.z
mul_pp r0.zw, r1.xyxy, r1.xyxy
add_pp_sat r0.z, r0, r0.w
add_pp r0.w, -r0.z, c10.y
mov_pp r3.xyz, v2
mad_pp r3.xyz, r1.z, v1, r3
dp3_pp r0.z, r3, r3
rsq_pp r0.w, r0.w
rsq_pp r0.z, r0.z
mul_pp r3.xyz, r0.z, r3
rcp_pp r1.z, r0.w
dp3_pp r0.w, r1, r3
mov_pp r0.z, c8.x
mul_pp r0.z, c13.x, r0
max_pp r0.w, r0, c12
pow r3, r0.w, r0.z
mad r0.zw, r1.w, r2.xyxy, v0.xyxy
add r0.w, r0, -c4.y
mul r2.x, r0.w, r0.y
mul r0.w, r0, r0.x
add r0.z, r0, -c4.x
mad r0.y, r0.z, r0, r0.w
mad r0.z, r0, r0.x, -r2.x
add r0.x, -r0.y, c4.y
mov r0.y, c3
mad r0.y, c0, r0, r0.x
add r0.x, -r0.z, c4
mov r0.z, c3.x
mad r0.x, c0.y, r0.z, r0
texld r0, r0, s1
mul_pp r2, r0, c7
dp3_pp r1.x, r1, v2
max_pp r0.x, r1, c12.w
mul_pp r1.xyz, r2, c1
mul_pp r0.xyz, r1, r0.x
mov r1.w, r3.x
mul r1.w, r0, r1
mov_pp r1.xyz, c1
texld r0.w, v3, s3
mul_pp r1.xyz, c2, r1
mul_pp r0.w, r0, c12.y
mad r0.xyz, r1, r1.w, r0
mul oC0.xyz, r0, r0.w
mov_pp oC0.w, r2
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
ConstBuffer "$Globals" 240 // 200 used size, 13 vars
Vector 16 [_LightColor0] 4
Vector 32 [_SpecColor] 4
Vector 112 [_PanMT] 4
Vector 128 [_RotMT] 4
Vector 144 [_PanPM] 4
Vector 160 [_RotPM] 4
Vector 176 [_Color] 4
Float 192 [_Shininess]
Float 196 [_Parallax]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_ParallaxMap] 2D 3
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_BumpMap] 2D 2
SetTexture 3 [_LightTexture0] 2D 0
// 60 instructions, 5 temp regs, 0 temp arrays:
// ALU 53 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedjfbjnmngkoefgdboaccamdidmkgigmfkabaaaaaakaajaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcjiaiaaaaeaaaaaaacgacaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaaddcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
afaaaaaadcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaakaaaaaaabeaaaaa
gballgdlabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaanlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaakaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaa
bcaabaaaabaaaaaaakaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaa
abaaaaaafgiecaiaebaaaaaaaaaaaaaaakaaaaaadiaaaaahjcaabaaaaaaaaaaa
agaabaaaaaaaaaaafgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaa
aaaaaaaaakaabaaaabaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaaj
dcaabaaaaaaaaaaaegaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaakaaaaaa
dcaaaaalccaabaaaabaaaaaabkiacaaaaaaaaaaaajaaaaaabkiacaaaabaaaaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaa
ajaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaa
aaaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaadaaaaaadiaaaaal
dcaabaaaaaaaaaaabgifcaaaaaaaaaaaamaaaaaaaceaaaaaaaaaaadpaaaaaaed
aaaaaaaaaaaaaaaadcaaaaalbcaabaaaaaaaaaaadkaabaaaaaaaaaaabkiacaaa
aaaaaaaaamaaaaaaakaabaiaebaaaaaaaaaaaaaabaaaaaahecaabaaaaaaaaaaa
egbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaafecaabaaaaaaaaaaackaabaaa
aaaaaaaadiaaaaahdcaabaaaabaaaaaakgakbaaaaaaaaaaaegbabaaaacaaaaaa
dcaaaaajicaabaaaaaaaaaaackbabaaaacaaaaaackaabaaaaaaaaaaaabeaaaaa
dnaknhdodcaaaaajhcaabaaaacaaaaaaegbcbaaaacaaaaaakgakbaaaaaaaaaaa
egbcbaaaadaaaaaaaoaaaaahpcaabaaaabaaaaaabgabbaaaabaaaaaapgapbaaa
aaaaaaaadcaaaaajpcaabaaaabaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaa
bgblbaaaabaaaaaaaaaaaaajpcaabaaaabaaaaaaegaobaaaabaaaaaabgibcaia
ebaaaaaaaaaaaaaaaiaaaaaadcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaa
aiaaaaaaabeaaaaagballgdlabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaanlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaa
aaaaaaaaaiaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaah
bcaabaaaaaaaaaaabcaabaaaadaaaaaaakaabaaaaaaaaaaadiaaaaahpcaabaaa
aeaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakfcaabaaaaaaaaaaa
fgahbaaaabaaaaaaagaabaaaadaaaaaaagacbaiaebaaaaaaaeaaaaaadcaaaaaj
dcaabaaaabaaaaaaigaabaaaabaaaaaaagaabaaaadaaaaaangafbaaaaeaaaaaa
aaaaaaajdcaabaaaabaaaaaaegaabaiaebaaaaaaabaaaaaafgifcaaaaaaaaaaa
aiaaaaaadcaaaaalmcaabaaaabaaaaaafgifcaaaaaaaaaaaahaaaaaafgifcaaa
abaaaaaaaaaaaaaaagaebaaaabaaaaaaaaaaaaajfcaabaaaaaaaaaaaagacbaia
ebaaaaaaaaaaaaaaagiacaaaaaaaaaaaaiaaaaaadcaaaaaldcaabaaaabaaaaaa
agiacaaaaaaaaaaaahaaaaaafgifcaaaabaaaaaaaaaaaaaaigaabaaaaaaaaaaa
efaaaaajpcaabaaaadaaaaaangafbaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaaefaaaaajpcaabaaaabaaaaaaigaabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadcaaaaapdcaabaaaadaaaaaahgapbaaaadaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaa
aaaaaaaaapaaaaahbcaabaaaaaaaaaaaegaabaaaadaaaaaaegaabaaaadaaaaaa
ddaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaai
bcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaaf
ecaabaaaadaaaaaaakaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaa
acaaaaaaegacbaaaacaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahncaabaaaaaaaaaaaagaabaaaaaaaaaaaagajbaaaacaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaadaaaaaaigadbaaaaaaaaaaabaaaaaahecaabaaa
aaaaaaaaegacbaaaadaaaaaaegbcbaaaadaaaaaadeaaaaakfcaabaaaaaaaaaaa
agacbaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacpaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaabkaabaaaaaaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahbcaabaaaaaaaaaaadkaabaaaabaaaaaaakaabaaaaaaaaaaadiaaaaaj
hcaabaaaacaaaaaaegiccaaaaaaaaaaaabaaaaaaegiccaaaaaaaaaaaacaaaaaa
diaaaaahlcaabaaaaaaaaaaaagaabaaaaaaaaaaaegaibaaaacaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaalaaaaaadiaaaaai
iccabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaaaaaaaaaaalaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaadcaaaaaj
hcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaaeaaaaaaeghobaaaadaaaaaaaagabaaa
aaaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaa
diaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3"
}

}
	}

#LINE 58

}

FallBack "Animated/Built-in/Transparent/Bumped Specular"
}
