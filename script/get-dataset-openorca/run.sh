cmd=${CM_RUN_CMD}
echo "${cmd}"
eval "${cmd}"
test $? -eq 0 || exit $?
