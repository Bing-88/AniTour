document.addEventListener("DOMContentLoaded", function () {
    const toggleIcon = document.getElementById("togglePasswordIcon");
    const eyeOpen = document.getElementById("eyeOpen");
    const eyeClosed = document.getElementById("eyeClosed");
    const toggleText = document.querySelector(".toggle-text");
    const password = document.getElementById("password");
    const password2 = document.getElementById("password2");

    toggleIcon.addEventListener("click", function () {
        const isPassword = password.type === "password";
        password.type = isPassword ? "text" : "password";
        if (password2) password2.type = isPassword ? "text" : "password";

        eyeOpen.style.display = isPassword ? "none" : "inline";
        eyeClosed.style.display = isPassword ? "inline" : "none";
        toggleText.textContent = isPassword ? "Nascondi password" : "Mostra password";
    });
});