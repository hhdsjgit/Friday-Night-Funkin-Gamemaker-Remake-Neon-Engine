/// @function xml_read_file(filename)
/// @description 读取XML文件并返回解析后的数据
/// @param {string} filename 文件名
function xml_read_file(filename) {
    // 使用buffer读取文件
    if (!file_exists(filename)) {
        show_debug_message("错误: 文件不存在 " + filename);
        return noone;
    }
    
    var buffer = buffer_load(filename);
    if (buffer == -1) {
        show_debug_message("错误: 无法读取文件 " + filename);
        return noone;
    }
    
    // 读取buffer内容为字符串
    buffer_seek(buffer, buffer_seek_start, 0);
    var xml_string = buffer_read(buffer, buffer_string);
    buffer_delete(buffer);
    
    if (xml_string == "") {
        show_debug_message("错误: 文件内容为空 " + filename);
        return noone;
    }
    
    return xml_parse_string(xml_string);
}

/// @function xml_parse_string(xml_string)
/// @description 解析XML字符串
/// @param {string} xml_string XML字符串
function xml_parse_string(xml_string) {
    var root_map = ds_map_create();
    root_map[? "_type"] = "xml_document";
    
    // 移除XML声明和注释
    xml_string = xml_remove_comments(xml_string);
    xml_string = xml_remove_declaration(xml_string);
    
    // 解析根元素
    var root_content = xml_extract_content(xml_string, 1);
    if (root_content != "") {
        var root_tag = xml_parse_tag_name(root_content);
        var root_element = xml_parse_element(root_content);
        if (root_element != noone) {
            ds_map_add(root_map, root_tag, root_element);
        }
    }
    
    return root_map;
}

/// @function xml_parse_element(xml_string)
/// @description 解析XML元素
/// @param {string} xml_string XML字符串
function xml_parse_element(xml_string) {
    var element_map = ds_map_create();
    element_map[? "_type"] = "xml_element";
    
    // 查找开始标签
    var tag_start = string_pos("<", xml_string);
    var tag_end = string_pos(">", xml_string);
    
    if (tag_start == 0 || tag_end == 0) {
        ds_map_destroy(element_map);
        return noone;
    }
    
    var full_tag = string_copy(xml_string, tag_start + 1, tag_end - tag_start - 1);
    var tag_name = xml_parse_tag_name(full_tag);
    var attributes = xml_parse_attributes(full_tag);
    
    ds_map_add(element_map, "_attributes", attributes);
    
    // 查找结束标签
    var end_tag = "</" + tag_name + ">";
    var content_start = tag_end + 1;
    var content_string = string_copy(xml_string, content_start, string_length(xml_string));
    var content_end = string_pos(end_tag, content_string);
    
    if (content_end > 0) {
        var content = string_trim(string_copy(content_string, 1, content_end - 1));
        
        // 检查内容是否包含子元素
        if (string_pos("<", content) > 0) {
            // 包含子元素
            var children = xml_parse_children(content);
            ds_map_add(element_map, "_children", children);
        } else {
            // 纯文本内容
            ds_map_add(element_map, "_content", content);
        }
    }
    
    return element_map;
}

/// @function xml_parse_children(xml_string)
/// @description 解析子元素
/// @param {string} xml_string XML字符串
function xml_parse_children(xml_string) {
    var children_map = ds_map_create();
    var remaining = xml_string;
    
    while (string_length(remaining) > 0) {
        // 查找下一个开始标签
        var tag_start = string_pos("<", remaining);
        if (tag_start == 0) break;
        
        // 跳过注释和声明
        if (string_copy(remaining, tag_start, 4) == "<!--") {
            var comment_end = string_pos("-->", remaining);
            if (comment_end > 0) {
                remaining = string_copy(remaining, comment_end + 3, string_length(remaining));
                continue;
            }
        }
        
        if (string_copy(remaining, tag_start, 2) == "<?") {
            var decl_end = string_pos("?>", remaining);
            if (decl_end > 0) {
                remaining = string_copy(remaining, decl_end + 2, string_length(remaining));
                continue;
            }
        }
        
        var element_content = xml_extract_content(remaining, tag_start);
        if (element_content != "") {
            var element = xml_parse_element(element_content);
            if (element != noone) {
                var attributes = element[? "_attributes"];
                var element_name = attributes[? "_tagname"];
                if (element_name != undefined) {
                    // 如果已经有同名元素，转换为数组
                    if (ds_map_exists(children_map, element_name)) {
                        var existing = children_map[? element_name];
                        if (is_ds_map(existing) && ds_map_exists(existing, "_type")) {
                            // 转换为数组
                            var new_list = ds_list_create();
                            ds_list_add(new_list, existing);
                            ds_list_add(new_list, element);
                            ds_map_add(children_map, element_name, new_list);
                        } else if (is_ds_list(existing)) {
                            ds_list_add(existing, element);
                        }
                    } else {
                        ds_map_add(children_map, element_name, element);
                    }
                }
            }
            
            // 更新剩余字符串
            var end_pos = tag_start + string_length(element_content);
            remaining = string_copy(remaining, end_pos, string_length(remaining));
        } else {
            break;
        }
    }
    
    return children_map;
}

/// @function xml_extract_content(xml_string, start_pos)
/// @description 提取完整的元素内容
/// @param {string} xml_string XML字符串
/// @param {real} start_pos 开始位置
function xml_extract_content(xml_string, start_pos) {
    var sub_string = string_copy(xml_string, start_pos, string_length(xml_string));
    var tag_start = string_pos("<", sub_string);
    var tag_end = string_pos(">", sub_string);
    
    if (tag_start == 0 || tag_end == 0) return "";
    
    var full_tag = string_copy(sub_string, tag_start + 1, tag_end - tag_start - 1);
    var tag_name = xml_parse_tag_name(full_tag);
    
    // 查找结束标签
    var end_tag = "</" + tag_name + ">";
    var content_end = string_pos(end_tag, sub_string);
    
    if (content_end > 0) {
        return string_copy(sub_string, 1, content_end + string_length(end_tag) - 1);
    }
    
    return "";
}

/// @function xml_parse_tag_name(full_tag)
/// @description 解析标签名
/// @param {string} full_tag 完整标签
function xml_parse_tag_name(full_tag) {
    var space_pos = string_pos(" ", full_tag);
    if (space_pos > 0) {
        return string_copy(full_tag, 1, space_pos - 1);
    }
    return full_tag;
}

/// @function xml_parse_attributes(full_tag)
/// @description 解析属性
/// @param {string} full_tag 完整标签
function xml_parse_attributes(full_tag) {
    var attr_map = ds_map_create();
    var tag_name = xml_parse_tag_name(full_tag);
    ds_map_add(attr_map, "_tagname", tag_name);
    
    // 移除标签名部分
    var attr_string = string_copy(full_tag, string_length(tag_name) + 1, string_length(full_tag));
    attr_string = string_trim(attr_string);
    
    var pos = 1;
    while (pos < string_length(attr_string)) {
        // 查找属性名
        var eq_pos = string_pos("=", attr_string);
        if (eq_pos == 0) break;
        
        var attr_name = string_trim(string_copy(attr_string, 1, eq_pos - 1));
        
        // 查找属性值
        var quote_char = string_char_at(attr_string, eq_pos + 1);
        if (quote_char != "\"" && quote_char != "'") {
            break;
        }
        
        var value_start = eq_pos + 2;
        var quote_end = string_pos(quote_char, string_copy(attr_string, value_start, string_length(attr_string)));
        
        if (quote_end == 0) break;
        
        var attr_value = string_copy(attr_string, value_start, quote_end - 1);
        ds_map_add(attr_map, attr_name, attr_value);
        
        // 更新剩余字符串
        attr_string = string_copy(attr_string, value_start + quote_end, string_length(attr_string));
        attr_string = string_trim(attr_string);
        pos = 1;
    }
    
    return attr_map;
}

/// @function xml_remove_comments(xml_string)
/// @description 移除注释
/// @param {string} xml_string XML字符串
function xml_remove_comments(xml_string) {
    var result = xml_string;
    var comment_start = string_pos("<!--", result);
    
    while (comment_start > 0) {
        var comment_end = string_pos("-->", result);
        if (comment_end > comment_start) {
            var before = string_copy(result, 1, comment_start - 1);
            var after = string_copy(result, comment_end + 3, string_length(result));
            result = before + after;
        } else {
            break;
        }
        comment_start = string_pos("<!--", result);
    }
    
    return result;
}

/// @function xml_remove_declaration(xml_string)
/// @description 移除XML声明
/// @param {string} xml_string XML字符串
function xml_remove_declaration(xml_string) {
    var result = xml_string;
    var decl_start = string_pos("<?", result);
    
    if (decl_start > 0) {
        var decl_end = string_pos("?>", result);
        if (decl_end > decl_start) {
            result = string_copy(result, decl_end + 2, string_length(result));
        }
    }
    
    return result;
}

/// @function xml_get_value(xml_data, path)
/// @description 通过路径获取XML值
/// @param {real} xml_data XML数据(ds_map)
/// @param {string} path 路径 (例如: "root/player/name")
function xml_get_value(xml_data, path) {
    if (!is_ds_map(xml_data)) return undefined;
    
    var parts = string_split(path, "/");
    var current = xml_data;
    
    for (var i = 0; i < array_length(parts); i++) {
        var part = parts[i];
        if (is_ds_map(current) && ds_map_exists(current, part)) {
            current = current[? part];
        } else {
            return undefined;
        }
    }
    
    if (is_ds_map(current) && ds_map_exists(current, "_content")) {
        return current[? "_content"];
    }
    
    return current;
}

/// @function xml_get_attribute(xml_element, attr_name)
/// @description 获取元素属性
/// @param {real} xml_element XML元素(ds_map)
/// @param {string} attr_name 属性名
function xml_get_attribute(xml_element, attr_name) {
    if (!is_ds_map(xml_element)) return undefined;
    
    if (ds_map_exists(xml_element, "_attributes")) {
        var attributes = xml_element[? "_attributes"];
        if (is_ds_map(attributes) && ds_map_exists(attributes, attr_name)) {
            return attributes[? attr_name];
        }
    }
    return undefined;
}

/// @function xml_get_element_name(xml_element)
/// @description 获取元素名称
/// @param {real} xml_element XML元素(ds_map)
function xml_get_element_name(xml_element) {
    if (!is_ds_map(xml_element)) return "";
    
    if (ds_map_exists(xml_element, "_attributes")) {
        var attributes = xml_element[? "_attributes"];
        if (is_ds_map(attributes) && ds_map_exists(attributes, "_tagname")) {
            return attributes[? "_tagname"];
        }
    }
    return "";
}

/// @function xml_destroy(xml_data)
/// @description 销毁XML数据，释放内存
/// @param {real} xml_data XML数据(ds_map)
function xml_destroy(xml_data) {
    if (is_ds_map(xml_data) && ds_map_exists(xml_data, "_type")) {
        xml_destroy_recursive(xml_data);
    }
}

/// @function xml_destroy_recursive(data)
/// @description 递归销毁XML数据
function xml_destroy_recursive(data) {
    if (!is_ds_map(data)) return;
    
    var map_keys = ds_map_find_all(data);
    for (var i = 0; i < ds_map_size(data); i++) {
        var key = map_keys[i];
        var value = data[? key];
        
        if (is_ds_map(value)) {
            if (ds_map_exists(value, "_type")) {
                xml_destroy_recursive(value);
            }
            ds_map_destroy(value);
        } else if (is_ds_list(value)) {
            var list_size = ds_list_size(value);
            for (var j = 0; j < list_size; j++) {
                var item = value[| j];
                if (is_ds_map(item) && ds_map_exists(item, "_type")) {
                    xml_destroy_recursive(item);
                }
            }
            ds_list_destroy(value);
        }
    }
    ds_map_destroy(data);
}

/// @function is_ds_map(value)
/// @description 检查值是否为ds_map
/// @param {any} value 要检查的值
function is_ds_map(value) {
    return is_ds_map(value);
}

/// @function is_ds_list(value)
/// @description 检查值是否为ds_list
/// @param {any} value 要检查的值
function is_ds_list(value) {
    return is_ds_list(value);
}