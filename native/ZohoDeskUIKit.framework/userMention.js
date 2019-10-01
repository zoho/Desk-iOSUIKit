function getSelectedElement() {
    return document.getSelection().getRangeAt(0).startContainer.parentElement;
}


function keyPressed(){
    if (getSelectedElement().innerText.includes("@")){
        var _selection = document.getSelection(),
        _anchorNode = _selection.anchorNode,
        range = _selection.getRangeAt(0),
        newRange = range.cloneRange(),
        contents,
        currText,
        textContent,
        pos;
        
        newRange.setStart(_anchorNode, 0);
        contents = newRange.cloneContents();
        textContent = contents.textContent;
        pos = textContent.lastIndexOf('@');
        currText = textContent.substr(pos + 1).trim();
        var text = textContent.substr(pos)
        var spaceCheck = text.includes(" ");
        var atCheck = text.charAt(0);
        if ( !spaceCheck && atCheck=="@") {
            caretOffset=document.getSelection().anchorNode.parentNode.offsetTop
            fireURL("searchMention:"+currText);// No I18N
        }
    }
}



function fireURL(urlString){
    var iframe = document.createElement("IFRAME");
    iframe.setAttribute("src", urlString);
    document.documentElement.appendChild(iframe);
    iframe.parentNode.removeChild(iframe);
    iframe = null;
}


function replaceSuggestion(customTag){
    var _selection = document.getSelection()
    _selection.modify("extend", "backward", "word")// No I18N
    _selection.modify("extend", "backward", "character")// No I18N
    document.execCommand('insertHTML', true, customTag+"&nbsp");// No I18N
    return document.getElementById("editor").innerHTML
}



function getCursorPoint() {
    return document.getSelection().anchorNode.parentNode.offsetTop
}
