function updateLogoSrc() {
  const logo = document.getElementById('logo-full');
  if (!logo) return;
  if (window.innerWidth <= 600) {
    logo.src = "/AniTour/images/logo_anitour.png";
  } else {
    logo.src = "/AniTour/images/logo_anitour_full.png";
  }
}
window.addEventListener('resize', updateLogoSrc);
window.addEventListener('DOMContentLoaded', updateLogoSrc);