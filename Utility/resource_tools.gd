class_name ResourceTools
extends RefCounted

static func find_resources(dir_path: String) -> Array[String]:
	# Trim trailing slashes to make concatinating easier.
	dir_path = dir_path.trim_suffix("/")

	# Get the directory.
	var dir: DirAccess = DirAccess.open(dir_path)
	if not dir:
		push_warning("Unable to find_resources(%s)" % dir_path)
		return []

	# Collect the paths to the files.
	var file_paths: Array[String] = []

	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		# When running from the editor, the text resources just there.
		if file_name.ends_with(".tres"):
			file_paths.append("%s/%s" % [dir_path, file_name])
		# However, when running from a standalone export, they are packed up
		# and a .remap is available that points to the real location.
		elif file_name.ends_with(".tres.remap"):
			file_paths.append("%s/%s" % [dir_path, file_name.trim_suffix(".remap")])
		file_name = dir.get_next()
	dir.list_dir_end()

	return file_paths
