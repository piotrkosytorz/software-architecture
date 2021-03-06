/*
 * $Id: logical-ops.sql 4809 2011-11-20 21:12:35Z unsaved $
 *
 * Test logical operations.
 */

* three = 3
* four = 4

*if (3 != 3)
    \q 3 != 3
*end if

*if (3 == 4)
    \q 3 == 4
*end if

*if (3 > 4)
    \q 3 > 4
*end if

*if (!4 > 3)
    \q !4 > 3
*end if

*if (3 >= 4)
    \q 3 >= 4
*end if

*if (4 =< 3)
    \q 4 =< 3
*end if

*if (*unset1 != *unset2)
    \q *unset1 != *unset2
*end if

*if (3 == three)
    \q 3 == three
*end if

*if (3 == four)
    \q 3 == four
*end if

* blankVar1 =
* blankVar2 =
*if (*blankVar1 != *blankVar2)
    \q *blankVar1 != *blankVar2
*end if

*if (*blankVar1 == *unset1)
    \q *blankVar1 == *unset1
*end if

*if (*{blankVar1} != *{blankVar2})
    \q *{blankVar1} != *{blankVar2}
*end if
