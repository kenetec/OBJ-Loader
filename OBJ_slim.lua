-- The MIT License (MIT)

-- Copyright (c) 2015 unvanish

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
assert(io,"Requires io library to function!");function Vertex(e,o,n,l)return{x=tonumber(e)or 0,y=tonumber(o)or 0,z=tonumber(n)or 0,w=tonumber(l)or 1,};end
function UV(n,e,o)return{u=tonumber(n)or 0,v=tonumber(e)or 0,w=tonumber(o)or 0,};end
function free_form(n,o,e)return{u=tonumber(n),v=tonumber(o)or nil,w=tonumber(e)or nil,};end
function Normal(o,n,e)return{x=tonumber(o)or 0,y=tonumber(n)or 0,z=tonumber(e)or 0,};end
function FaceData(e,r,r,n,o,l)return{vertex_index=tonumber(e)or-1,uv_index=tonumber(e)or-1,normal_index=tonumber(e)or-1,vertex=n or{},uv=o or{},normal=l or{},};end
function Face(e)return{data={},material_name=e or"";};end
function MinimalObjModel()return{vertices={},uvs={},normals={};space_vertices={},faces={},};end
function MeshObjectModel(e,n)local e={name=e;group_name=n or"";};for n,o in next,MinimalObjModel()do e[n]=o;end
return e;end
function GroupModel(e)return{name=e;};end
function ObjModel()local e={objects={},groups={},material_file_name="",poly_count=poly_count or 0,};for o,n in next,MinimalObjModel()do e[o]=n;end
return e;end
function MtlModel()return{};end
local function t(l)local n={};local e="";local o=1;for l in l:gmatch('.')do
if(l~="/")then
e=e..l;else
n[#n+1]=e;e="";o=o+1;end
end
if(e~="")then
n[#n+1]=e;end
return n,o;end
local function i(l,n,e)local o=Face(e);for r=1,#n do
local e=FaceData();local r,n=t(n[r]);for n=1,n do
v=tonumber(r[n])or r[n];if(n==1)then
e.vertex_index=v;e.vertex=l.vertices[v];elseif(n==2)then
e.uv_index=v;e.uv=l.uvs[v];elseif(n==3)then
e.normal_index=v;e.normal=l.normals[v];end
end
o.data[#o.data+1]=e;end
return o;end
local function c(t,o)o=o or{scale=1;};local r="";local n,a=MinimalObjModel(),nil;local r={['#']=function(e,e)end,['mtllib']=function(e,n)e.material_file_name=n[1];end,['usemtl']=function(n,e)r=e[1];end,['v']=function(o,e,l)local e=Vertex(e[1]*l.scale,e[2]*l.scale,e[3]*l.scale,e[4]);o.vertices[#o.vertices+1]=e
n.vertices[#o.vertices]=true;end,['vt']=function(o,e,l)local e=UV(e[1]*l.scale,e[2]*l.scale,e[3]);o.uvs[#o.uvs+1]=e;n.uvs[#o.uvs]=true;end,['vn']=function(l,e,o)local e=Normal(e[1]*o.scale,e[2]*o.scale,e[3]*o.scale);l.normals[#l.normals+1]=e;n.normals[#l.normals]=true;end,['vp']=function(o,e,l)local e=free_form(e[1],e[2],e[3]);o.space_vertices[#o.space_vertices+1]=e;n.space_vertices[#o.space_vertices]=true;end,['f']=function(e,o,l)local o=i(e,o,r);e.faces[#e.faces+1]=o;n.faces[#e.faces]=true;e.poly_count=e.poly_count+1;end,['o']=function(o,e,l)local e=MeshObjectModel(e[1],a);o.objects[#o.objects+1]=e;n=e;end,['g']=function(e,n)local n=GroupModel(n[1]);e.groups[#e.groups+1]=n;a=n;end,};local e=assert(io.open(t,"r"),'"'..t..'" does not exist!');local l=ObjModel();for n in e:lines()do
if(n~="")then
local e={};for n in n:gmatch("%S+")do
e[#e+1]=n;end
local n=e[1];if(r[n])then
table.remove(e,1);r[n](l,e,o);end
end
end
return l;end
local function t(r)local o;local l={["#"]=function()end,["newmtl"]=function(e,n)e[n[1]]={};o=e[n[1]];end,};local e=assert(io.open(r,"r"),'"'..r..'" does not exist!');local r=MtlModel();for n in e:lines()do
if(n~="")then
local e={};for n in n:gmatch("%S+")do
e[#e+1]=n;end
local n=e[1];table.remove(e,1);if(l[n])then
l[n](r,e);else
if(o)then
o[n]=e;end
end
end
end
return r;end
local e={};function e.load(o,n)local l=o:match("^.*\\")or o:match("^.*/");local o=c(o,n);n=n or{mtl_dir=l;}local l;if(o.material_file_name~="")then
local e=n.mtl_dir..o.material_file_name;l=t(e);end
return{Obj=o;Mtl=l;};end
e.loadObj=c;e.loadMtl=t;return e;
