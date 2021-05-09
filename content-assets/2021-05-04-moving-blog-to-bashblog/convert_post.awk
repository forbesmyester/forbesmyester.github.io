BEGIN {
    TAGS=""
    CATEGORY=""
    PRINT=0
    TITLE=""
}
match($0, /^tags: +(.*)/, match_arr) {
    TAGS=match_arr[1]
    $0=""
}
match($0, /^category: +(.*)/, match_arr) {
    CATEGORY=match_arr[1]
    $0=""
}
match($0, /^title: +(.*)/, match_arr) {
    TITLE=match_arr[1]
}
PRINT==1 { print $0 }
TITLE && match($0, /^---/) {
    print "#", TITLE
    print ""
    PRINT=1
}
END {
    if (TAGS && CATEGORY) {
        printf "Tags: %s, %s", TAGS, CATEGORY
        exit 0
    }
    if (TAGS) {
        printf "Tags: %s", TAGS
        exit 0
    }
    if (CATEGORY) {
        printf "Tags: %s", CATEGORY
        exit 0
    }
}
