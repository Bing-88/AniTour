document.addEventListener("DOMContentLoaded", function () {
    const password = document.getElementById("password");
    const password2 = document.getElementById("password2");
    const warning = document.getElementById("capsWarning");

    const checkCapsLock = (e) => {
        warning.style.display = e.getModifierState("CapsLock") ? "block" : "none";
    };

    password.addEventListener("keyup", checkCapsLock);
    if (password2) password2.addEventListener("keyup", checkCapsLock);
});