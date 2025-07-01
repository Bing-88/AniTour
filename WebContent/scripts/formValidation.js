document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("signupForm");
    const username = document.getElementById("username");
    const email = document.getElementById("email");
    const password = document.getElementById("password");
    const password2 = document.getElementById("password2");

    const usernameError = document.getElementById("usernameError");
    const emailError = document.getElementById("emailError");
    const passwordError = document.getElementById("passwordError");
    const password2Error = document.getElementById("password2Error");

    const validateUsername = () => {
        const usernameValue = username.value.trim();
        if (usernameValue.length < 3 || usernameValue.length > 20) {
            usernameError.textContent = "Il nome utente deve essere tra 3 e 20 caratteri.";
            return false;
        }
        usernameError.textContent = "";
        return true;
    };

    const validateEmail = () => {
        const emailValue = email.value.trim();
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(emailValue)) {
            emailError.textContent = "Inserisci un'email valida.";
            return false;
        }
        emailError.textContent = "";
        return true;
    };

    const validatePassword = () => {
        const passwordValue = password.value.trim();
        if (passwordValue.length < 8) {
            passwordError.textContent = "La password deve essere almeno di 8 caratteri.";
            return false;
        }
        passwordError.textContent = "";
        return true;
    };

    const validatePassword2 = () => {
        const passwordValue = password.value.trim();
        const password2Value = password2.value.trim();
        if (passwordValue !== password2Value) {
            password2Error.textContent = "Le password non corrispondono.";
            return false;
        }
        password2Error.textContent = "";
        return true;
    };

    username.addEventListener("change", validateUsername);
    email.addEventListener("change", validateEmail);
    password.addEventListener("change", validatePassword);
    password2.addEventListener("change", validatePassword2);

    form.addEventListener("submit", function (event) {
        const isUsernameValid = validateUsername();
        const isEmailValid = validateEmail();
        const isPasswordValid = validatePassword();
        const isPassword2Valid = validatePassword2();

        if (!isUsernameValid || !isEmailValid || !isPasswordValid || !isPassword2Valid) {
            event.preventDefault();
        }
    });
});