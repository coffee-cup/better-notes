// Import styles

import 'tachyons/css/tachyons.css';
import '../scss/app.scss';

// Import dependencies

// import socket from './socket';

// Elm

import Elm from '../../elm/Main.elm';

const elmDiv = document.getElementById('elm-main');

const tokenKey = 'token';
const app = Elm.Main.embed(elmDiv, {
  prod: process.env.NODE_ENV === 'production',
  websocketUrl: process.env.WEBSOCKET_URL,
  token: localStorage.getItem(tokenKey) || ''
});

app.ports.saveToken.subscribe(token => {
  localStorage.setItem(tokenKey, token);
});
