function main_game(){

}

function create_note(x_pos, note_arrow, mustHitSection, length, worry) {
    var note_obj = instance_create_depth(x_pos, 800, -15, obj_note)
    note_obj.note_arrow = note_arrow
    note_obj.Note_length = length
    note_obj.Note_mustHitSection = mustHitSection
    note_obj.worry_note = worry
    return note_obj
}