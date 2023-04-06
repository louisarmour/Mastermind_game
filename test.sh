#!/bin/bash
# A simple test script, for unit-testing of the matching function of the Master Mind program

# function to check output from running $cmd against expected output
check () {
    echo "Cmd: $cmd"
    echo "Output: \n$out"
    echo "Expected: \n$exp"
    if [ "$out" = "$exp" ]
    then echo ".. OK"
	 ok=$(( $ok + 1))
    else echo "** WRONG"
	 ret=1
    fi
    n=$(( $n + 1))
}

# name of the application to run
cw=cw3
# return code; 0 = ok, anything else is an error
ret=0
ok=0
n=0

# -------------------------------------------------------
# a sequence of unit tests

cmd="./${cw} -u 123 321"
out="`$cmd`"
exp=$(cat <<EOS
1 exact matches
2 approximate matches
EOS
)
check

cmd="./${cw} -u 121 313"
out="`$cmd`"
exp=$(cat <<EOS
0 exact matches
1 approximate matches
EOS
)
check

cmd="./${cw} -u 132 321"
out="`$cmd`"
exp=$(cat <<EOS
0 exact matches
3 approximate matches
EOS
)
check

cmd="./${cw} -u 123 112"
out="`$cmd`"
exp=$(cat <<EOS
1 exact matches
1 approximate matches
EOS
)
check

cmd="./${cw} -u 112 233"
out="`$cmd`"
exp=$(cat <<EOS
0 exact matches
1 approximate matches
EOS
)
check

cmd="./${cw} -u 111 333"
out="`$cmd`"
exp=$(cat <<EOS
0 exact matches
0 approximate matches
EOS
)
check

cmd="./${cw} -u 331 223"
out="`$cmd`"
exp=$(cat <<EOS
0 exact matches
1 approximate matches
EOS
)
check

cmd="./${cw} -u 331 232"
out="`$cmd`"
exp=$(cat <<EOS
1 exact matches
0 approximate matches
EOS
)
check

cmd="./${cw} -u 232 331"
out="`$cmd`"
exp=$(cat <<EOS
1 exact matches
0 approximate matches
EOS
)
check

cmd="./${cw} -u 312 312"
out="`$cmd`"
exp=$(cat <<EOS
3 exact matches
0 approximate matches
EOS
)
check

# return status code (0 for ok, 1 for not)
echo "$ok of $n tests are OK"
exit $ret
