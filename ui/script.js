const UI = document.getElementById("main");
const itemsContainer = document.getElementById("items");
const missionEasy = document.getElementById("mission-easy");
const missionMedium = document.getElementById("mission-medium");
const missionHard = document.getElementById("mission-hard");
const cancelMission = document.getElementById("cancel-mission");


let missionCooldowns = {
    "mission-easy": null,
    "mission-medium": null,
    "mission-hard": null,
};

let activeMission = null; 

window.addEventListener("DOMContentLoaded", () => {
    if (UI) {
        UI.style.display = "none";
    }
});

window.addEventListener("message", (e) => {
    if (!UI || !itemsContainer) {
        return;
    }

    if (e.data.action === "open") {
        UI.style.display = "block";

        if (e.data.activeMission) {
            activeMission = e.data.activeMission;
        } else {
            activeMission = null;
        }
        updateButton();
    }
    if (e.data.action === "close") {
        UI.style.display = "none";
    }
});

function cancelMissionHandler() {
    if (!activeMission) {
        return;
    }

    activeMission = null; 
    fetch(`https://${GetParentResourceName()}/cancelMission`, { method: "POST" });
    updateButton(); 
}

cancelMission.addEventListener("click", cancelMissionHandler);


function isCooldown(missionId) {
    const cooldownEndTime = missionCooldowns[missionId];
    if (!cooldownEndTime) {
        return false;
    }

    const currentTime = new Date().getTime();
    const isActive = currentTime < cooldownEndTime;
    return isActive;
}

function startCooldown(missionId, minutes) {
    const currentTime = new Date().getTime();
    missionCooldowns[missionId] = currentTime + minutes * 60 * 1000;
}

function updateButton() {
    const currentTime = new Date().getTime();

    for (const [missionId, button] of Object.entries({
        "mission-easy": missionEasy,
        "mission-medium": missionMedium,
        "mission-hard": missionHard,
    })) {
        if (activeMission && activeMission !== missionId) {
            button.classList.add("disabled");
            button.disabled = true;
            button.querySelector(".cooldown-text").textContent = "You got a active mission!";
        } else {
            const cooldownEndTime = missionCooldowns[missionId];
            if (cooldownEndTime && currentTime < cooldownEndTime) {
                const remainingTimeMs = cooldownEndTime - currentTime;
                const remainingMinutes = Math.floor(remainingTimeMs / 1000 / 60);
                const remainingSeconds = Math.floor((remainingTimeMs / 1000) % 60);
                const formattedSeconds = remainingSeconds < 10 ? `0${remainingSeconds}` : remainingSeconds;

                button.classList.add("disabled");
                button.disabled = true;
                button.querySelector(".cooldown-text").textContent = `(Cooldown: ${remainingMinutes}:${formattedSeconds})`;
            } else {
                button.classList.remove("disabled");
                button.disabled = false;
                button.querySelector(".cooldown-text").textContent = "";
            }
        }
    }

    if (activeMission) {
        cancelMission.classList.remove("disabled");
        cancelMission.disabled = false;
    } else {
        cancelMission.classList.add("disabled");
        cancelMission.disabled = true;
    }
}

function startMission(missionId, cooldownMinutes) {
    if (activeMission) {
        return;
    }

    console.log(`${missionId} started`);
    activeMission = missionId; 
    fetch(`https://${GetParentResourceName()}/${missionId}`, { method: "POST" });
    startCooldown(missionId, cooldownMinutes);
    updateButton();
}

function completeMission() {
    console.log("Mission completed");
    activeMission = null;
    updateButton();
}

setInterval(updateButton, 1000);

document.getElementById("close")?.addEventListener("click", () => {
    fetch(`https://${GetParentResourceName()}/closeUI`, { method: "POST" }).then(() => {
    });
});

missionEasy.addEventListener("click", () => startMission("mission-easy", 2));
missionMedium.addEventListener("click", () => startMission("mission-medium", 5));
missionHard.addEventListener("click", () => startMission("mission-hard", 20));

