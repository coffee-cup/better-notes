// Import styles

import 'tachyons/css/tachyons.css';
import '../scss/app.scss';

// Import dependencies

// import socket from './socket';

const mq = window.matchMedia('(max-width: 48em)');
let onMobile = false;
if (mq.matches) {
  onMobile = true;
}

// Elm

import Elm from '../../elm/Main.elm';

const elmDiv = document.getElementById('elm-main');

const tokenKey = 'token';
const app = Elm.Main.embed(elmDiv, {
  prod: process.env.NODE_ENV === 'production',
  websocketUrl: process.env.WEBSOCKET_URL,
  token: localStorage.getItem(tokenKey) || '',
  onMobile
});

app.ports.saveToken.subscribe(token => {
  localStorage.setItem(tokenKey, token);
});

app.ports.scrollToBottom.subscribe(() => {
  // Short delay so new note has been added to the DOM
  setTimeout(() => {
    const notesList = document.querySelector('.notes-list-wrapper');
    notesList.scrollTop = notesList.scrollHeight;
  }, 100);
});
