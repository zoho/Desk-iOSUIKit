
 "use strict";

var RE = {};

window.onload = function() {
    RE.initialHeight();
};

RE.initialHeight = function(){
    var clientHeight = Math.max(document.body.scrollHeight, document.body.offsetHeight,document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);
    
    RE.callback("ready:"+clientHeight);// NO I18N
}
RE.postClientHeight = function(){
    var clientHeight = Math.max(document.body.scrollHeight, document.body.offsetHeight,document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);
    
    RE.callback("clientHeight:"+clientHeight);// NO I18N
}


RE.editor = document.getElementById('editor');// NO I18N

// Not universally supported, but seems to work in iOS 7 and 8
document.addEventListener("selectionchange", function() {// NO I18N
    RE.backuprange();
});

//looks specifically for a Range selection and not a Caret selection
RE.rangeSelectionExists = function() {
    //!! coerces a null to bool
    var sel = document.getSelection();
    if (sel && sel.type == "Range") {// NO I18N
        return true;
    }
    return false;
};

RE.rangeOrCaretSelectionExists = function() {
    //!! coerces a null to bool
    var sel = document.getSelection();
    if (sel && (sel.type == "Range" || sel.type == "Caret")) {// NO I18N
        return true;
    }
    return false;
};

RE.editor.addEventListener("input", function() {// NO I18N
    RE.updatePlaceholder();
    RE.backuprange();
    var relativePostion = RE.getRelativeCaretYPosition();
    var htmlContent = RE.editor.innerHTML;
    var text = RE.getText();
    var lineHeight = RE.getLineHeight();
    RE.callback("relativePostion:"+relativePostion);// NO I18N
    RE.callback("htmlContent<1565593103>"+htmlContent);// NO I18N
    RE.callback("text<1565593103>"+text);// NO I18N
    RE.postClientHeight();
//    RE.callback("lineHeight:"+lineHeight);
//    RE.callback("input");
});

RE.editor.addEventListener("focus", function() {// NO I18N
    RE.backuprange();
    RE.callback("focus");// NO I18N
});

RE.editor.addEventListener("blur", function() {// NO I18N
    RE.callback("blur");// NO I18N
});

RE.customAction = function(action) {
    RE.callback("action/" + action);// NO I18N
};

RE.updateHeight = function() {
    RE.callback("updateHeight");// NO I18N
}

RE.getCommandQueue = function() {
    var commands = JSON.stringify(RE.callbackQueue);
    RE.callbackQueue = [];
    return commands;
};

RE.callback = function(method) {
    window.webkit.messageHandlers.postmessage.postMessage(method);
};

RE.setHtml = function(contents) {
    var tempWrapper = document.createElement('div');
    tempWrapper.innerHTML = contents;
    var images = tempWrapper.querySelectorAll("img");// NO I18N

    for (var i = 0; i < images.length; i++) {
        images[i].onload = RE.updateHeight;
    }

    RE.editor.innerHTML = tempWrapper.innerHTML;
    RE.updatePlaceholder();
    RE.postClientHeight();
};

RE.getHtml = function() {
    return RE.editor.innerHTML;
};

RE.getText = function() {
    return RE.editor.innerText;
};

RE.setBaseTextColor = function(color) {
    RE.editor.style.color  = color;
};

RE.setPlaceholderText = function(text) {
    RE.editor.setAttribute("placeholder", text);// NO I18N
};

RE.updatePlaceholder = function() {
    if (RE.editor.innerHTML.indexOf('img') !== -1 || (RE.editor.textContent.length > 0 && RE.editor.innerHTML.length > 0)) {
        RE.editor.classList.remove("placeholder");// NO I18N
    } else {
        RE.editor.classList.add("placeholder");// NO I18N
    }
};

RE.removeFormat = function() {
    document.execCommand('removeFormat', false, null);
};

RE.setFontSize = function(size) {
    RE.editor.style.fontSize = size;
};

RE.setBackgroundColor = function(color) {
    RE.editor.style.backgroundColor = color;
};

RE.setHeight = function(size) {
    RE.editor.style.height = size;
};

RE.undo = function() {
    document.execCommand('undo', false, null);
};

RE.redo = function() {
    document.execCommand('redo', false, null);
};

RE.setBold = function() {
    document.execCommand('bold', false, null);
};

RE.setItalic = function() {
    document.execCommand('italic', false, null);
};

RE.setSubscript = function() {
    document.execCommand('subscript', false, null);
};

RE.setSuperscript = function() {
    document.execCommand('superscript', false, null);
};

RE.setStrikeThrough = function() {
    document.execCommand('strikeThrough', false, null);
};

RE.setUnderline = function() {
    document.execCommand('underline', false, null);
};

RE.setTextColor = function(color) {
    RE.restorerange();
    document.execCommand("styleWithCSS", null, true);// NO I18N
    document.execCommand('foreColor', false, color);
    document.execCommand("styleWithCSS", null, false);// NO I18N
};

RE.setTextBackgroundColor = function(color) {
    RE.restorerange();
    document.execCommand("styleWithCSS", null, true);// NO I18N
    document.execCommand('hiliteColor', false, color);
    document.execCommand("styleWithCSS", null, false);// NO I18N
};

RE.setHeading = function(heading) {
    document.execCommand('formatBlock', false, '<h' + heading + '>');
};

RE.setIndent = function() {
    document.execCommand('indent', false, null);
};

RE.setOutdent = function() {
    document.execCommand('outdent', false, null);
};

RE.setOrderedList = function() {
    document.execCommand('insertOrderedList', false, null);
};

RE.setUnorderedList = function() {
    document.execCommand('insertUnorderedList', false, null);
};

RE.setJustifyLeft = function() {
    document.execCommand('justifyLeft', false, null);
};

RE.setJustifyCenter = function() {
    document.execCommand('justifyCenter', false, null);
};

RE.setJustifyRight = function() {
    document.execCommand('justifyRight', false, null);
};

RE.getLineHeight = function() {
    return RE.editor.style.lineHeight;
};

RE.setLineHeight = function(height) {
    RE.editor.style.lineHeight = height;
};

RE.insertImage = function(url, alt) {
    var img = document.createElement('img');
    img.setAttribute("src", url);// NO I18N
    img.setAttribute("alt", alt);// NO I18N
    img.onload = RE.updateHeight;

    RE.insertHTML(img.outerHTML);
    RE.callback("input");// NO I18N
};

RE.setBlockquote = function() {
    document.execCommand('formatBlock', false, '<blockquote>');
};

RE.insertHTML = function(html) {
    RE.restorerange();
    document.execCommand('insertHTML', false, html);
};

RE.insertLink = function(url, title) {
    RE.restorerange();
    var sel = document.getSelection();
    if (sel.toString().length !== 0) {
        if (sel.rangeCount) {

            var el = document.createElement("a");// NO I18N
            el.setAttribute("href", url);// NO I18N
            el.setAttribute("title", title);// NO I18N

            var range = sel.getRangeAt(0).cloneRange();
            range.surroundContents(el);
            sel.removeAllRanges();
            sel.addRange(range);
        }
    }
    RE.callback("input");// NO I18N
};

RE.prepareInsert = function() {
    RE.backuprange();
};

RE.backuprange = function() {
    var selection = window.getSelection();
    if (selection.rangeCount > 0) {
        var range = selection.getRangeAt(0);
        RE.currentSelection = {
            "startContainer": range.startContainer,
            "startOffset": range.startOffset,
            "endContainer": range.endContainer,
            "endOffset": range.endOffset
        };
    }
};

RE.addRangeToSelection = function(selection, range) {
    if (selection) {
        selection.removeAllRanges();
        selection.addRange(range);
    }
};

// Programatically select a DOM element
RE.selectElementContents = function(el) {
    var range = document.createRange();
    range.selectNodeContents(el);
    var sel = window.getSelection();
    // this.createSelectionFromRange sel, range
    RE.addRangeToSelection(sel, range);
};

RE.restorerange = function() {
    var selection = window.getSelection();
    selection.removeAllRanges();
    var range = document.createRange();
    range.setStart(RE.currentSelection.startContainer, RE.currentSelection.startOffset);
    range.setEnd(RE.currentSelection.endContainer, RE.currentSelection.endOffset);
    selection.addRange(range);
};

RE.focus = function() {
    var range = document.createRange();
    range.selectNodeContents(RE.editor);
    range.collapse(false);
    var selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);
    RE.editor.focus();
};

RE.focusAtPoint = function(x, y) {
    var range = document.caretRangeFromPoint(x, y) || document.createRange();
    var selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);
    RE.editor.focus();
};

RE.blurFocus = function() {
    RE.editor.blur();
};

/**
Recursively search element ancestors to find a element nodeName e.g. A
**/
var _findNodeByNameInContainer = function(element, nodeName, rootElementId) {
    if (element.nodeName == nodeName) {
        return element;
    } else {
        if (element.id === rootElementId) {
            return null;
        }
        _findNodeByNameInContainer(element.parentElement, nodeName, rootElementId);
    }
};

var isAnchorNode = function(node) {
    return ("A" == node.nodeName);
};

RE.getAnchorTagsInNode = function(node) {
    var links = [];

    while (node.nextSibling !== null && node.nextSibling !== undefined) {
        node = node.nextSibling;
        if (isAnchorNode(node)) {
            links.push(node.getAttribute('href'));
        }
    }
    return links;
};

RE.countAnchorTagsInNode = function(node) {
    return RE.getAnchorTagsInNode(node).length;
};

/**
 * If the current selection's parent is an anchor tag, get the href.
 * @returns {string}
 */
RE.getSelectedHref = function() {
    var href, sel;
    href = '';
    sel = window.getSelection();
    if (!RE.rangeOrCaretSelectionExists()) {
        return null;
    }

    var tags = RE.getAnchorTagsInNode(sel.anchorNode);
    //if more than one link is there, return null
    if (tags.length > 1) {
        return null;
    } else if (tags.length == 1) {
        href = tags[0];
    } else {
        var node = _findNodeByNameInContainer(sel.anchorNode.parentElement, 'A', 'editor');
        href = node.href;
    }

    return href ? href : null;
};

// Returns the cursor position relative to its current position onscreen.
// Can be negative if it is above what is visible
RE.getRelativeCaretYPosition = function() {
    var y = 0;
    var sel = window.getSelection();
    if (sel.rangeCount) {
        var range = sel.getRangeAt(0);
        var needsWorkAround = (range.startOffset == 0)
        /* Removing fixes bug when node name other than 'div' */
        // && range.startContainer.nodeName.toLowerCase() == 'div');
        if (needsWorkAround) {
            y = range.startContainer.offsetTop - window.pageYOffset;
        } else {
            if (range.getClientRects) {
                var rects=range.getClientRects();
                if (rects.length > 0) {
                    y = rects[0].top;
                }
            }
        }
    }

    return y;
};
