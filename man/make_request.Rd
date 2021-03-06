% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_request.R
\name{make_request}
\alias{make_request}
\alias{do_request}
\alias{do_paginated_request}
\title{Make a request for the Google Drive v3 API}
\usage{
make_request(x, ...)

do_request(x, ...)

do_paginated_request(x, ..., n_max = Inf, n = function(res) 1,
  verbose = TRUE)
}
\arguments{
\item{x}{List, holding the components for an HTTP request, presumably created
with \code{\link[=generate_request]{generate_request()}} or \code{\link[=build_request]{build_request()}}. Should contain the
\code{method}, \code{path}, \code{query}, \code{body}, \code{token}, and \code{url}.}

\item{...}{Optional arguments passed through to the HTTP method.}

\item{n_max}{Maximum number of items to return. Defaults to \code{Inf}, i.e. there
is no limit and we keep making requests until we get all items.}

\item{n}{Function that computes the number of items in one response or page.
The default function always returns \code{1} and therefore treats each page as
an item. If you know more about the structure of the response, you can
pass another function to count and threshhold, for example, the number of
files or comments.}

\item{verbose}{Logical, indicating whether to print informative messages
(default \code{TRUE}).}
}
\value{
\code{make_request()}: Object of class \code{response} from \link{httr}.

\code{do_request()}: List representing the content returned by a single
request.

\code{do_paginated_request()}: List of lists, representing the returned
content, one component per page.
}
\description{
Low-level functions to execute one or more Drive API requests and, perhaps,
process the response(s). Most users should, instead, use higher-level
wrappers that facilitate common tasks, such as uploading or downloading Drive
files. The functions here are intended for internal use and for programming
around the Drive API. Three functions are documented here:
\itemize{
\item \code{make_request()} does the bare minimum: just calls an HTTP method, only
adding the googledrive user agent. Typically the input is created with
\code{\link[=generate_request]{generate_request()}} or \code{\link[=build_request]{build_request()}} and the output is
processed with \code{\link[=process_response]{process_response()}}.
\item \code{do_request()} is simply \code{process_response(make_request(x, ...))}. It
exists only because we had to make \code{do_paginated_request()} and it felt
weird to not make the equivalent for a single request.
\item \code{do_paginated_request()} executes the input request \strong{with page
traversal}. It is impossible to separate paginated requests into a "make
request" step and a "process request" step, because the token for the
next page must be extracted from the content of the current page.
Therefore this function does both and returns a list of processed
responses, one per page.
}
}
\examples{
\dontrun{
## build a request for an endpoint that is:
##   * paginated
##   * NOT privileged in googledrive, i.e. not covered by generate_request()
## "comments" are a great example
## https://developers.google.com/drive/v3/reference/comments
##
## Practice with a target file with > 2 comments
## Note that we request 2 items (comments) per page
req <- build_request(
  path = "drive/v3/files/{fileId}/comments",
  method = "GET",
  params = list(
    fileId = "your-file-id-goes-here",
    fields = "*",
    pageSize = 2
  ),
  token = googledrive:::drive_token()
)
## make the paginated request, but cap it at 1 page
## should get back exactly two comments
do_paginated_request(req, n_max = 1)
}
}
\seealso{
Other low-level API functions: \code{\link{drive_token}},
  \code{\link{generate_request}},
  \code{\link{process_response}}
}
