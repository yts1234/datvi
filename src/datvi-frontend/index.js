let triviaDiv = document.getElementById("trivia-message");
let triviaButton = document.getElementById("trivia-button");

triviaButton.addEventListener("click", (event) => {
  triviaDiv.innerHTML = "";
  fetch("http://datvi-backend:8081/trivia")
    .then((res) => res.json())
    .then((trivia) => {
      triviaDiv.innerHTML = `<p>"${trivia.message}"</p>`;
    });
});
