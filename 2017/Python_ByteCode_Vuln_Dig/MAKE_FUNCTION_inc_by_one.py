
function inc_by_one()
LOAD_CONST 'AAAAAAAA\x0C\x58\x1D\x1ECCCCDDDDEEEEFFFFGGGG\x08\x58\x1D\x1E'
MAKE_FUNCTION 0
return

CALL_FUNCTION 'inc_by_one'
CALL_FUNCTION 'inc_by_one'
CALL_FUNCTION 'inc_by_one'
CALL_FUNCTION 'inc_by_one'

LOAD_CONST 'OK ..'
PRINT_ITEM
PRINT_NEWLINE
