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


-- OBJ.lua
-- 	by unvanish

	-- Notes --

-- For UVs remember to do 1-V for DXT compressed textures
-- Optimize code
-- Objects simply hold indicies that point to their data


	-- Classes --

-- 	Mesh
-- 		table 		Obj
-- 		table 		Mtl

-- 	ObjModel()
-- 		table 		vertices
-- 			Vertex

-- 		table 		uvs
-- 			UV

-- 		table 		normals
-- 			Normal

-- 		table 		faces
-- 			Face

-- 		table 		space_vertices
-- 			free_form

--		table 		objects
--			MeshObjectModel

--		table 		groups
-- 			GroupModel

-- 		table 		indicies
-- 			MinimalObjModel

-- 		string 		material_file_name

-- 		number 		poly_count

-- 	MtlModel()
-- 		table 		{}

-- LineIndex(lineNumber, line, data)
-- 		number 		lineNumber
-- 		string 		line
-- 		any 		data

-- Vertex(x, y, z[, w])
-- 		number 		x
-- 		number 		y
-- 		number 		z
-- 		number 		w

-- Normal(x, y, z)
-- 		number 		x
-- 		number 		y
-- 		number 		z

-- Face([material_name])
-- 		table 		data
-- 			FaceData

--		string 		material_name

-- UV(u, v)
-- 		number 		u
-- 		number 		v
-- 		number 		w

-- FaceData([vertex_index, uv_index, normal_index, vertex, uv, normal])
-- 		number 		vertex_index
-- 		number 		uv_index
-- 		number 		normal_index

-- 		Vertex 		vertex
-- 		UV 			uv
-- 		Normal 		normal

-- MinimalObjModel()
-- 		table 		vertices
-- 		table 		uvs
-- 		table 		normals
-- 		table 		faces
-- 		table 		space_vertices

-- MeshObjectModel(name, group_name)
-- 		table 		vertices
--			boolean

-- 		table 		uvs
--			boolean

-- 		table 		normals
--			boolean

-- 		table 		faces
--			boolean

-- 		table 		space_vertices
--			boolean

-- 		string 		name
-- 		string 		group_name

-- GroupModel(name)
-- 		string 		name


	-- Functions --

-- MeshModel load(string filePath, table settings = {
-- 	scale = 1,
-- })

-- Loads .obj file and .mtl file with applied settings, returns Mesh.



-- ObjModel loadObj(string filePath, table settings)

-- Loads .obj file with applied settings.



-- MtlModel loadMtl(string filePath)

-- Loads .mtl file.

---------------------------------------------------------------------------
assert(io, "Requires io library to function!");
---------------------------------------------------------------------------
function Vertex(x, y, z, w)
	return {
		x = tonumber(x) or 0,
		y = tonumber(y) or 0,
		z = tonumber(z) or 0,
		w = tonumber(w) or 1,
	};
end
---------------------------------------------------------------------------
function UV(u, v, w)
	return {
		u = tonumber(u) or 0,
		v = tonumber(v) or 0,
		w = tonumber(w) or 0,
	};
end
---------------------------------------------------------------------------
function free_form(u, v, w)
	return {
		u = tonumber(u),
		v = tonumber(v) or nil,
		w = tonumber(w) or nil,
	};
end
---------------------------------------------------------------------------
function Normal(x, y, z)
	return {
		x = tonumber(x) or 0,
		y = tonumber(y) or 0,
		z = tonumber(z) or 0,
	};
end
---------------------------------------------------------------------------
function FaceData(vertex_index, uv_index, normal_index, vertex, uv, normal)
	return {
		vertex_index = tonumber(vertex_index) or -1,
		uv_index = tonumber(vertex_index) or -1,
		normal_index = tonumber(vertex_index) or -1,

		vertex = vertex or {},
		uv = uv or {},
		normal = normal or {},
	};
end
---------------------------------------------------------------------------
function Face(material_name)
	return {
		data = {
			-- [1] = FaceData()
		},

		material_name = material_name or "";
	};
end
---------------------------------------------------------------------------
function MinimalObjModel()
	return {
		vertices = {},
		uvs = {},
		normals = {};

		space_vertices = {},
		faces = {},
	};
end
---------------------------------------------------------------------------
function MeshObjectModel(name, group_name)
	local r = {
		name = name;
		group_name = group_name or "";
	};

	for i, v in next, MinimalObjModel() do r[i] = v;end

	return r;
end
---------------------------------------------------------------------------
function GroupModel(name)
	return {
		name = name;
	};
end
---------------------------------------------------------------------------
function ObjModel()
	local model = {
		objects = {},
		groups = {},

		material_file_name = "",
		poly_count = poly_count or 0,
	};

	-- Merge
	for i, v in next, MinimalObjModel() do model[i] = v; end

	return model;
end
---------------------------------------------------------------------------
function MtlModel()
	return {};
end
---------------------------------------------------------------------------
local function _split(txt)
	local list = {};
	local str = "";

	local occurances = 1;

	for char in txt:gmatch('.') do
		if (char ~= "/") then
			str = str .. char;
		else
			list[#list+1] = str;
			str = "";
			occurances = occurances+1;
		end
	end

	if (str ~= "") then
		list[#list+1] = str;
	end

	return list, occurances;
end
---------------------------------------------------------------------------
local function _readFace(model, token, material)
	local face = Face(material);

	for t_i = 1, #token do
		local data = FaceData();
		local numbers, index = _split(token[t_i]);

		for i = 1, index do
			v = tonumber(numbers[i]) or numbers[i];
			if (i == 1) then
				data.vertex_index = v;
				data.vertex = model.vertices[v];
			elseif (i == 2) then
				data.uv_index = v;
				data.uv = model.uvs[v];
			elseif (i == 3) then
				data.normal_index = v;
				data.normal = model.normals[v];
			end
		end

		face.data[#face.data+1] = data;
	end

	return face;
end
---------------------------------------------------------------------------
local function loadObj(filePath, settings)
	settings = settings or {
		scale = 1;
	};

	local active_material = "";

	local active_object, active_group = MinimalObjModel(), nil;
	---------------------------------------------------------------------------
	local obj_Operations = {
		--[[
			# is a comment, skip these
		--]]
		['#'] = function(model, token) end,

		--[[
			mtllib denotes a required mtl file
		--]]
		['mtllib'] = function(model, token)
			model.material_file_name = token[1];
		end,

		--[[
			usemtl tells what material to use for the faces
		--]]
		['usemtl'] = function(model, token)
			active_material = token[1];
		end,

		--[[
			v denotes vertex
		--]]
		['v'] = function(model, token, settings)
			local v = Vertex(token[1] * settings.scale, token[2] * settings.scale, token[3] * settings.scale, token[4]);

			model.vertices[#model.vertices+1] = v
			active_object.vertices[#model.vertices] = true;
		end,

		--[[
			vt denotes texture coordinates(UV)
		--]]
		['vt'] = function(model, token, settings)
			local uv = UV(token[1] * settings.scale, token[2] * settings.scale, token[3]);

			model.uvs[#model.uvs+1] = uv;
			active_object.uvs[#model.uvs] = true;
		end,

		--[[
			vn denotes normal
		--]]
		['vn'] = function(model, token, settings)
			local normal = Normal(token[1] * settings.scale, token[2] * settings.scale, token[3] * settings.scale);

			model.normals[#model.normals+1] = normal;
			active_object.normals[#model.normals] = true;
		end,

		--[[
			vp denotes free form geometry
		--]]
		['vp'] = function(model, token, settings)
			local vp = free_form(token[1], token[2], token[3]);

			model.space_vertices[#model.space_vertices+1] = vp;
			active_object.space_vertices[#model.space_vertices] = true;
		end,

		--[[
			f denotes faces
		--]]
		['f'] = function(model, token, settings)
			local face = _readFace(model, token, active_material);
			model.faces[#model.faces+1] = face;

			active_object.faces[#model.faces] = true;

			model.poly_count = model.poly_count+1;
		end,

		--[[
			o denotes object
		--]]
		['o'] = function(model, token, settings)
			local object = MeshObjectModel(token[1], active_group);

			model.objects[#model.objects+1] = object;
			active_object = object;
		end,

		--[[
			g denotes group
		--]]
		['g'] = function(model, token)
			local group = GroupModel(token[1]);

			model.groups[#model.groups+1] = group;
			active_group = group;
		end,
	};
	---------------------------------------------------------------------------
	local file = assert(io.open(filePath, "r"), "\"" .. filePath .. "\" does not exist!");

	local model = ObjModel();

	for line in file:lines() do
		if (line ~= "") then
			local token = {};
			for tk in line:gmatch("%S+") do
				token[#token+1] = tk;
			end

			local identifier = token[1];
			if (obj_Operations[identifier]) then
				table.remove(token, 1);
				obj_Operations[identifier](model, token, settings);
			end
		end
	end

	return model;
end
---------------------------------------------------------------------------
local function loadMtl(filePath)
	local active_material;
	---------------------------------------------------------------------------
	local mtl_Operations = {
		["#"] = function() end,

		["newmtl"] = function(model, token)
			model[token[1]] = {};
			active_material = model[token[1]];
		end,
	};
	---------------------------------------------------------------------------
	local file = assert(io.open(filePath, "r"), "\"" .. filePath .. "\" does not exist!");

	local model = MtlModel();

	for line in file:lines() do
		if (line ~= "") then
			local token = {};
			for tk in line:gmatch("%S+") do
				token[#token+1] = tk;
			end

			local identifier = token[1];
			table.remove(token, 1);

			if (mtl_Operations[identifier]) then
				mtl_Operations[identifier](model, token);
			else
				-- add to active material
				if (active_material) then
					active_material[identifier] = token;
				end
			end
		end
	end

	return model;
end
---------------------------------------------------------------------------
local M = {};
---------------------------------------------------------------------------
function M.load(filePath, settings)
	local relativePath = filePath:match("^.*\\") or filePath:match("^.*/");

	local obj = loadObj(filePath, settings);

	settings = settings or {
		mtl_dir = relativePath;
	}
    
    local mtl;
    if (obj.material_file_name ~= "") then
        local mtlFilePath = settings.mtl_dir .. obj.material_file_name;
        mtl = loadMtl(mtlFilePath);
    end

	return {
		Obj = obj;
		Mtl = mtl;
	};
end
---------------------------------------------------------------------------
M.loadObj = loadObj;
M.loadMtl = loadMtl;
---------------------------------------------------------------------------
return M;
