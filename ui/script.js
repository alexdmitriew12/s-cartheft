const UI = document.getElementById("main");
const itemsContainer = document.getElementById("items");
const missionEasy = document.getElementById("mission-easy");

window.addEventListener('DOMContentLoaded', () => {
    if(UI) {
        UI.style.display = "none"
    }
})

window.addEventListener('message', (e) => {
    if(!UI || !items) {
        console.error("UI error");
        return;
    }

    if(e.data.action === 'open') {
        UI.style.display = "block";

        
    }

    if(e.data.action === 'close') {
        UI.style.display = 'none';
    }
})

document.getElementById('close')?.addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/closeUI`, { method: 'POST' })
})

missionEasy.addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/mission-easy`, {
        method: 'POST' 
    }).then(response => response.json())
        .then(data => console.log(data))
        .catch(error => console.error('Error:', error));
});