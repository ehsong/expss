
# this entire method for compatibility with other packages where 
# "labelled' is single class rather than c("labelled", "numeric") etc.
#' @export
as.data.frame.labelled = function(x, ..., nm = paste(deparse(substitute(x), width.cutoff = 500L)) ){
    if(length(class(x))>1){
        # because we can have labelled matrices or factors with variable label
        NextMethod("as.data.frame", ..., nm = nm)
        
    } else {
        # this branch for other packages where "labelled' is single class rather than c("labelled", "numeric") etc.
        
        as.data.frame.vector(x, ..., nm = nm)
    }
}

#' @export
c.labelled = function(..., recursive = FALSE)
    ### concatenate vectors of class 'labelled' and preserve labels
{
    y = NextMethod("c")
    vectors=list(...)
    dummy= lapply(vectors,var_lab)
    dummy=dummy[lengths(dummy)>0]
    if (length(dummy)>0) var_lab(y)=dummy[[1]]
    
    dummy= lapply(vectors,val_lab)
    val_lab(y)=do.call(combine_labels,dummy)
    class(y) = union("labelled",class(y))
    y
}



#' @export
rep.labelled = function (x, ...){
    y=NextMethod("rep")
    var_attr(y)=var_attr(x)
    class(y) = class(x)
    y	
}

#' @export
'[.labelled' = function (x, ...){
    y = NextMethod("[")
    var_attr(y)=var_attr(x)
    class(y) = class(x)
    y
}


# it is needed to prevent state with inconsistent class and mode
# (such as 'numeric' in class but mode is character)
#' @export
'[<-.labelled' = function (x, ..., value){
    class(x) = setdiff(class(x), "labelled")
    y = NextMethod("[")
    class(y) = c("labelled", class(y))
    y
}


var_attr = function(x){
    list(label=var_lab(x),labels=val_lab(x))
}

'var_attr<-' = function(x,value){
    var_lab(x)=value$label
    val_lab(x)=value$labels
    x
}

#' @export
"[.simple_table" = function(x, i, j, ...){
    res = `[.data.frame`(x, i, j, drop = FALSE)  
    class(res) = class(x)
    res
}


