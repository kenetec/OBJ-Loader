OBJ.lua
======

**OBJ.lua** is a *"bare-bones"* .obj loader. Designed to save the trouble of parsing the .obj & .mtl files and head straight into importing.  

**OBJ.lua** only depends on Lua's standard io library. If io is not available, it is free to edit to intake strings as well.

## Functions
This library comes equipped with 3 functions.  
**functions are written in C prototype format, see Classes for reference on the return values*

```lua
Mesh load(string file_path_to_obj_file[, table settings])
```
```load()``` is the easiest function to use.  It will load the .obj file and its linked material file(.mtl) from ```file_path_to_obj_file```. ```settings``` is a table which holds options for how **OBJ.lua** will manipulate or find data.  

```lua
ObjModel loadObj(string file_path_to_obj_file[, table settings])
```
```loadObj()``` is a simplified version of ```load()```, as it only loads the .obj file.  

```lua
MtlModel loadMtl(string file_path_to_mtl_file)
```
If you need to only load .mtl file, use ```loadMtl()```.

---
*Remember, if you only need to only load a .obj or .mtl file, use ```loadObj()``` or ```loadMtl()```, it is more faster and efficient.*

---


## Settings
```scale = #```
Scale the mesh by whatever amount.

```mtl_dir = "directory of mtl file"``` 
In any case where the .obj file is in a different directory from the .mtl file, set this value to the directory where the .mtl is.

## Classes

*Format explanation:  The name following the bullet can be either a function or a table, anything tabbed underneath is returned in a table.*

### Models
* Mesh  
-- 		ObjModel Obj  
-- 		MtlModel  Mtl  

* ObjModel()  
-- table  < Vertex > vertices  
	-- 		table < UV > 					uvs  
	-- 		table < Normal > 				normals  
	-- 		table < Face > 				faces  
	-- 		table < free_form > 			space_vertices  
	--		table < MeshObjectModel > 		objects  
	--		table < GroupModel > 			groups  
	-- 		table < MinimalObjModel > 		indicies  

	-- 		string 						material_file_name  
	-- 		number 						poly_count  

* MtlModel()  
	-- 		table 		{}  

* MinimalObjModel()  
	-- 		table < Vertex > 				vertices  
	-- 		table < UV > 					uvs  
	-- 		table < Normal > 				normals  
	-- 		table < Face > 				faces  
	-- 		table < free_form > 			space_vertices  

* MeshObjectModel(name, group_name)  
	-- 		table < boolean > 		vertices  
	-- 		table < boolean > 		uvs  
	-- 		table < boolean > 		normals  
	-- 		table < boolean > 		faces  
	-- 		table < boolean > 		space_vertices  

	-- 		string 				name  
	-- 		string 				group_name  

* GroupModel(name)  
	-- 		string 		name  


### Objects

* LineIndex(lineNumber, line, data)  
	-- 		number 		lineNumber  
	-- 		string 		line  
	-- 		any 		data  

* Vertex(x, y, z[, w])  
	-- 		number 		x  
	-- 		number 		y  
	-- 		number 		z  
	-- 		number 		w  

* Normal(x, y, z)  
	-- 		number 		x  
	-- 		number 		y  
	-- 		number 		z  

* Face([material_name])  
	-- 		table < FaceData > 		data  
	--		string 					material_name  

* UV(u, v)  
	-- 		number 		u  
	-- 		number 		v  
	-- 		number 		w  

* FaceData([vertex_index, uv_index, normal_index, vertex, uv, normal])  
	-- 		number 				vertex_index  
	-- 		number 				uv_index  
	-- 		number 				normal_index  

	-- 		table < Vertex > 		vertex  
	-- 		table < UV > 			uv  
	-- 		table < Normal > 		normal  


---  
*** This library is under the MIT License. ***
