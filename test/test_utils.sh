(( ut_count = 0 ))

function declare_ut()
{
    (( ut_count = ut_count + 1 ))
}

function assert_equal()
{
    lhs=${1}
    rhs=${2}
    if [[ ${lhs} == ${rhs} ]] ; then
        echo "ok - ${lhs} == ${rhs}"
    else
        echo "not ok - ${lhs} == ${rhs}"
    fi
}

function assert_true()
{
    statement=${1}

    if ${statement} ; then
        echo "ok - ${statement} -> TRUE"
    else
        echo "not ok - ${statement} -> FALSE"
    fi
}

function assert_false()
{
    statement=${1}

    if ! ${statement} ; then
        echo "ok - ${statement} -> FALSE"
    else
        echo "not ok - ${statement} -> TRUE"
    fi
}
