function highlightHouseWord() {
    const walker = document.createTreeWalker(
        document.body,
        NodeFilter.SHOW_TEXT,
        {
            acceptNode(node) {
                const parent = node.parentElement;

                if (
                    !parent ||
                    parent.closest('script, style, img, .house-blue, .house-word')
                ) {
                    return NodeFilter.FILTER_REJECT;
                }

                return /\bhouse\b/i.test(node.nodeValue)
                    ? NodeFilter.FILTER_ACCEPT
                    : NodeFilter.FILTER_REJECT;
            }
        }
    );

    const textNodes = [];

    while (walker.nextNode()) {
        textNodes.push(walker.currentNode);
    }

    textNodes.forEach((node) => {
        const fragment = document.createDocumentFragment();
        const parts = node.nodeValue.split(/(\bhouse\b)/gi);

        parts.forEach((part) => {
            if (/^house$/i.test(part)) {
                const span = document.createElement('span');
                span.className = 'house-blue';
                span.textContent = part;
                fragment.appendChild(span);
            } else {
                fragment.appendChild(document.createTextNode(part));
            }
        });

        node.parentNode.replaceChild(fragment, node);
    });
}


document.addEventListener('DOMContentLoaded', () => {
    highlightHouseWord();
});


let zoom = 1;
let posX = 0;
let posY = 0;
let isDragging = false;
let startX = 0;
let startY = 0;

function updateImageTransform(){
    const img = document.getElementById("modalImage");
    img.style.transform = `translate(${posX}px, ${posY}px) scale(${zoom})`;
}

function openImage(src){
    const modal = document.getElementById("imageModal");
    const img = document.getElementById("modalImage");

    modal.style.display = "flex";
    img.src = src;

    zoom = 1;
    posX = 0;
    posY = 0;

    updateImageTransform();
}

function closeImage(){
    document.getElementById("imageModal").style.display = "none";
}

document.addEventListener("DOMContentLoaded", function(){

    const closeButton = document.getElementById("closeModal");
    const modal = document.getElementById("imageModal");
    const img = document.getElementById("modalImage");

    closeButton.addEventListener("click", closeImage);

    modal.addEventListener("click", function(e){
        if(e.target === modal){
            closeImage();
        }
    });

    img.addEventListener("wheel", function(e){
        e.preventDefault();

        if(e.deltaY < 0){
            zoom += 0.15;
        }else{
            zoom -= 0.15;
        }

        zoom = Math.max(1, Math.min(5, zoom));

        if(zoom === 1){
            posX = 0;
            posY = 0;
        }

        updateImageTransform();
    });

    img.addEventListener("mousedown", function(e){
        if(zoom <= 1) return;

        isDragging = true;
        startX = e.clientX - posX;
        startY = e.clientY - posY;

        img.style.cursor = "grabbing";
    });

    document.addEventListener("mousemove", function(e){
        if(!isDragging) return;

        posX = e.clientX - startX;
        posY = e.clientY - startY;

        updateImageTransform();
    });

    document.addEventListener("mouseup", function(){
        isDragging = false;
        img.style.cursor = zoom > 1 ? "grab" : "zoom-in";
    });

});