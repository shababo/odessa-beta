function [return_info, success, handles] = ...
    do_instruction_local(instruction, handles)

[return_info,handles] = do_instruction(instruction,handles);
success = 1;