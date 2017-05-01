playing
================
Lucy D’Agostino McGowan
4/26/2017

-   [List](#list)
-   [Metadata](#metadata)
-   [User info](#user-info)
-   [Upload file](#upload-file)
-   [Delete file](#delete-file)

*side note, really excited to include emojis in a non-hacky way, thanks [emo::ji](http://github.com/hadley/emo)* 🌻

``` r
library('googledrive')
library('dplyr')
```

List
----

`gd_ls()` pulls out name, type, & id (we probably don't want to see id, but seems useful to have here, so we could pick which one we want to get more info on?)

``` r
gd_ls()
```

    ## # A tibble: 100 × 3
    ##              name                     type
    ##             <chr>                    <chr>
    ## 1  This is a test                 document
    ## 2            test                 document
    ## 3            test                 document
    ## 4            test                 document
    ## 5        Untitled application/octet-stream
    ## 6        Untitled application/octet-stream
    ## 7            name                 document
    ## 8        Untitled application/octet-stream
    ## 9        Untitled application/octet-stream
    ## 10       Untitled application/octet-stream
    ## # ... with 90 more rows, and 1 more variables: id <chr>

We can search using regular expressions

``` r
gd_ls(search = "test")
```

    ## # A tibble: 13 × 3
    ##                    name                   type
    ##                   <chr>                  <chr>
    ## 1        This is a test               document
    ## 2                  test               document
    ## 3                  test               document
    ## 4                  test               document
    ## 5                  test               document
    ## 6                  test               document
    ## 7                  test               document
    ## 8                  test               document
    ## 9                  test               document
    ## 10             test9999           presentation
    ## 11            test12345               document
    ## 12            test12345               document
    ## 13 plotly-latest.min.js application/javascript
    ## # ... with 1 more variables: id <chr>

We can also pass additional query parameters through the `...`, for example

``` r
gd_ls(search = "test", orderBy = "modifiedTime")
```

    ## # A tibble: 1 × 3
    ##                                                 name        type
    ##                                                <chr>       <chr>
    ## 1 transcript differential expression testing dataset spreadsheet
    ## # ... with 1 more variables: id <chr>

Metadata
--------

Note: now it seems we have to specify the fields (in v2 where I was working previously, it would automatically output everything, see [this](https://developers.google.com/drive/v3/web/migration)).

List of all fields [here](https://developers.google.com/drive/v3/web/migration).

Now let's say I want to dive deeper into the top one

``` r
id <- gd_get_id("test")
file <- gd_file(id)
file
```

    ## File name: This is a test 
    ## File owner: Lucy D'Agostino 
    ## File type: document 
    ## Last modified: 2017-05-01

In addition to the things I've pulled out, there is a `tibble` of permissions as well as a `list` (now named `kitchen_sink`, this should change), that contains all output fields.

``` r
file$permissions
```

    ## # A tibble: 1 × 8
    ##               kind                   id  type            emailAddress
    ##              <chr>                <chr> <chr>                   <chr>
    ## 1 drive#permission 13813982488463916564  user lucydagostino@gmail.com
    ## # ... with 4 more variables: role <chr>, displayName <chr>,
    ## #   photoLink <chr>, deleted <lgl>

``` r
str(file$kitchen_sink)
```

    ## List of 1
    ##  $ :List of 27
    ##   ..$ kind                 : chr "drive#file"
    ##   ..$ id                   : chr "1PMmmnNCAAOAxA9sOlGhuRAsgQKZurOidAvlj0weMWKk"
    ##   ..$ name                 : chr "This is a test"
    ##   ..$ mimeType             : chr "application/vnd.google-apps.document"
    ##   ..$ starred              : logi FALSE
    ##   ..$ trashed              : logi FALSE
    ##   ..$ explicitlyTrashed    : logi FALSE
    ##   ..$ parents              :List of 1
    ##   .. ..$ : chr "0AA9rJumZU4vEUk9PVA"
    ##   ..$ spaces               :List of 1
    ##   .. ..$ : chr "drive"
    ##   ..$ version              : chr "38797"
    ##   ..$ webViewLink          : chr "https://docs.google.com/document/d/1PMmmnNCAAOAxA9sOlGhuRAsgQKZurOidAvlj0weMWKk/edit?usp=drivesdk"
    ##   ..$ iconLink             : chr "https://drive-thirdparty.googleusercontent.com/16/type/application/vnd.google-apps.document"
    ##   ..$ thumbnailLink        : chr "https://docs.google.com/feeds/vt?gd=true&id=1PMmmnNCAAOAxA9sOlGhuRAsgQKZurOidAvlj0weMWKk&v=2&s=AMedNnoAAAAAWQe7Y8tDUk1j4SEnBhLn"| __truncated__
    ##   ..$ viewedByMe           : logi TRUE
    ##   ..$ viewedByMeTime       : chr "2017-05-01T20:47:15.533Z"
    ##   ..$ createdTime          : chr "2017-05-01T20:33:29.415Z"
    ##   ..$ modifiedTime         : chr "2017-05-01T20:47:15.533Z"
    ##   ..$ modifiedByMeTime     : chr "2017-05-01T20:47:15.533Z"
    ##   ..$ owners               :List of 1
    ##   .. ..$ :List of 6
    ##   .. .. ..$ kind        : chr "drive#user"
    ##   .. .. ..$ displayName : chr "Lucy D'Agostino"
    ##   .. .. ..$ photoLink   : chr "https://lh5.googleusercontent.com/-9QyJNrSIw8U/AAAAAAAAAAI/AAAAAAAAAXY/zcdEycKqKQk/s64/photo.jpg"
    ##   .. .. ..$ me          : logi TRUE
    ##   .. .. ..$ permissionId: chr "13813982488463916564"
    ##   .. .. ..$ emailAddress: chr "lucydagostino@gmail.com"
    ##   ..$ lastModifyingUser    :List of 6
    ##   .. ..$ kind        : chr "drive#user"
    ##   .. ..$ displayName : chr "Lucy D'Agostino"
    ##   .. ..$ photoLink   : chr "https://lh5.googleusercontent.com/-9QyJNrSIw8U/AAAAAAAAAAI/AAAAAAAAAXY/zcdEycKqKQk/s64/photo.jpg"
    ##   .. ..$ me          : logi TRUE
    ##   .. ..$ permissionId: chr "13813982488463916564"
    ##   .. ..$ emailAddress: chr "lucydagostino@gmail.com"
    ##   ..$ shared               : logi FALSE
    ##   ..$ ownedByMe            : logi TRUE
    ##   ..$ capabilities         :List of 15
    ##   .. ..$ canAddChildren                : logi FALSE
    ##   .. ..$ canChangeViewersCanCopyContent: logi TRUE
    ##   .. ..$ canComment                    : logi TRUE
    ##   .. ..$ canCopy                       : logi TRUE
    ##   .. ..$ canDelete                     : logi TRUE
    ##   .. ..$ canDownload                   : logi TRUE
    ##   .. ..$ canEdit                       : logi TRUE
    ##   .. ..$ canListChildren               : logi FALSE
    ##   .. ..$ canMoveItemIntoTeamDrive      : logi TRUE
    ##   .. ..$ canReadRevisions              : logi TRUE
    ##   .. ..$ canRemoveChildren             : logi FALSE
    ##   .. ..$ canRename                     : logi TRUE
    ##   .. ..$ canShare                      : logi TRUE
    ##   .. ..$ canTrash                      : logi TRUE
    ##   .. ..$ canUntrash                    : logi TRUE
    ##   ..$ viewersCanCopyContent: logi TRUE
    ##   ..$ writersCanShare      : logi TRUE
    ##   ..$ permissions          :List of 1
    ##   .. ..$ :List of 8
    ##   .. .. ..$ kind        : chr "drive#permission"
    ##   .. .. ..$ id          : chr "13813982488463916564"
    ##   .. .. ..$ type        : chr "user"
    ##   .. .. ..$ emailAddress: chr "lucydagostino@gmail.com"
    ##   .. .. ..$ role        : chr "owner"
    ##   .. .. ..$ displayName : chr "Lucy D'Agostino"
    ##   .. .. ..$ photoLink   : chr "https://lh5.googleusercontent.com/-9QyJNrSIw8U/AAAAAAAAAAI/AAAAAAAAAXY/zcdEycKqKQk/s64/photo.jpg"
    ##   .. .. ..$ deleted     : logi FALSE
    ##   ..$ quotaBytesUsed       : chr "0"

User info
---------

``` r
gd_user()
```

    ## $user
    ## $user$kind
    ## [1] "drive#user"
    ## 
    ## $user$displayName
    ## [1] "Lucy D'Agostino"
    ## 
    ## $user$photoLink
    ## [1] "https://lh5.googleusercontent.com/-9QyJNrSIw8U/AAAAAAAAAAI/AAAAAAAAAXY/zcdEycKqKQk/s64/photo.jpg"
    ## 
    ## $user$me
    ## [1] TRUE
    ## 
    ## $user$permissionId
    ## [1] "13813982488463916564"
    ## 
    ## $user$emailAddress
    ## [1] "lucydagostino@gmail.com"
    ## 
    ## 
    ## attr(,"class")
    ## [1] "drive_user" "list"

Upload file
-----------

``` r
write.table("this is a test", file = "~/desktop/test.txt")
gd_upload(file = "~/desktop/test.txt", name = "This is a test", overwrite = TRUE)
```

    ## File uploaded to Google Drive: 
    ## ~/desktop/test.txt 
    ## As the Google document named:
    ## This is a test

``` r
file <- gd_file(gd_get_id("This is a test"))
file
```

    ## File name: This is a test 
    ## File owner: Lucy D'Agostino 
    ## File type: document 
    ## Last modified: 2017-05-01

Delete file
-----------

``` r
gd_delete(file)
```

    ## The file 'This is a test' has been deleted from your Google Drive