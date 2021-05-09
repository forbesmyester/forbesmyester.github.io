BEGIN { DONE=0 }
match($0, /^# +([^ ].*)/, match_arr) {
    if (! DONE) {
        $0 = match_arr[1]
        DONE = 1
    }
}
/\S/ { DONE = 1 }
{ print $0 }
