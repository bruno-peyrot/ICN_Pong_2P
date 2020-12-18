/*
      PONG
      par B. PEYROT
      décembre 2016
      Lycée Elisée Reclus de Sainte Foy La Grande
      pour le cours d'I.C.N.
*/


// Importation de la librairie Minim (son)
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// Déclaration des variables
boolean[] touches=new boolean[128];
PImage balle;
PImage terrain;
PImage fondballe;
PImage joueurgauche;
PImage fondgauche;
PImage joueurdroite;
PImage fonddroite;
PImage fondscore;
PFont police;
int x, y, dx, dy ,oldx, oldy;
int xgauche, ygauche, oldxgauche, oldygauche;
int xdroite, ydroite, oldxdroite, oldydroite;
int scoregauche, scoredroite;
Minim minim;
AudioSnippet rebond;
AudioSnippet raquette;
AudioSnippet perdu;
AudioSnippet finpartie;

void setup() {
  // Chargement des sprites
  balle = loadImage("balle.png");
  terrain = loadImage("terrain2.png");
  joueurgauche = loadImage("joueurgauche.png");
  joueurdroite = loadImage("joueurdroite.png");
  // Chargement des sons
  minim = new Minim(this);
  rebond = minim.loadSnippet("rebond.wav");
  raquette = minim.loadSnippet("raquette.wav");
  perdu = minim.loadSnippet("perdu.wav");
  finpartie = minim.loadSnippet("fin_partie.wav");
  // Chargement de la police
  police = createFont("LCD.ttf",80);
  textFont(police);
  // Initialisations
  oldx = 40;
  oldy = 270;
  x = 40;
  y = 270;
  dx = 4;
  dy = 4;
  oldxgauche = 20;
  oldygauche = 230;
  xgauche = 20;
  ygauche = 230;
  oldxdroite = 760;
  oldydroite = 230;
  xdroite = 760;
  ydroite = 230;
  scoregauche = 0;
  scoredroite = 0;
  size(800, 550);
  image(terrain, 0, 0);
  fondballe = get(oldx, oldy, 20, 20);
  fondgauche = get(oldxgauche, oldygauche, 20, 80);
  fonddroite = get(oldxdroite, oldydroite, 20, 80);
  fondscore = get(310, 10, 250, 100);
  fill(0);
  text("PONG",635,545);
}

void draw() {
  // Efface les positions précédentes de la balle et des raquettes
  image(fondballe, oldx, oldy);
  image(fondgauche, oldxgauche, oldygauche);
  image(fonddroite, oldxdroite, oldydroite);
  // Affiche le score actuel
  image(fondscore, 310, 10);
  fill(255, 0, 0);
  text(scoregauche, 320, 100);
  fill(0, 0, 255);
  text(scoredroite, 440, 100);
  // récupère le fond des nouvelles positions de la balle et des raquettes
  oldx = x;
  oldy = y;
  oldxgauche = xgauche;
  oldygauche = ygauche;
  oldxdroite = xdroite;
  oldydroite = ydroite;
  fondballe = get(x, y, 20, 20);
  fondgauche = get(xgauche, ygauche, 20, 80);
  fonddroite = get(xdroite, ydroite, 20, 80);
  // Affiche la balle et les raquettes
  image(balle, x, y);
  image(joueurgauche, xgauche, ygauche);
  image(joueurdroite, xdroite, ydroite);
  // Déplacement de la balle
  x = x + dx;
  y = y + dy;
  // Le joueur rouge a marqué le point ?
  if (x >= 780) {
    scoregauche++;
    if (scoregauche == 10) {
      scoregauche = 0;
      scoredroite = 0;
      finpartie.rewind();
      finpartie.play();
      delay(5000);
    }
    perdu.rewind();
    perdu.play();
    delay(1000);
    dx = -dx;
    x = xdroite - 20;
    y = ydroite + 40;
    raquette.rewind();
    raquette.play();
  }
  // Le joueur bleu a marqué le point ?
  if (x < 0) {
    scoredroite++;
    if (scoredroite == 10) {
      scoregauche = 0;
      scoredroite = 0;
      finpartie.rewind();
      finpartie.play();
      delay(5000);
    }
    perdu.rewind();
    perdu.play();
    delay(1000);
    dx = -dx;
    x = xgauche + 20;
    y = ygauche + 40;
    raquette.rewind();
    raquette.play();
  }
  // Rebond éventuel de la balle sur le haut ou le bas du terrain
  if ((y >= 530)||(y <= 0)) {
    dy = -dy;
    rebond.rewind();
    rebond.play();
  }
  // Déplacement de la raquette de gauche
  // La touche 'A' permet de monter...
  if ((verifieClavier('a')) && (ygauche > 4)) { ygauche = ygauche - 4;}
  // ... la touche 'Q' de descendre
  if ((verifieClavier('q')) && (ygauche < 466)) {ygauche = ygauche + 4;}
  // Déplacement de la raquette de droite
  // La touche 'P' permet de monter...
  if ((verifieClavier('p')) && (ydroite > 4)) {ydroite = ydroite - 4;}
  // ... la touche 'M' permet de descendre
  if ((verifieClavier('m')) && (ydroite < 466)) {ydroite = ydroite + 4;}
  // Gestion des rebonds de la balle sur les raquettes
  // Raquette du joueur de gauche
  if ((x == xgauche + 20) && (y > ygauche - 4) && (y < ygauche + 84) && (dx < 0)) {
    dx = -dx;
    raquette.rewind();
    raquette.play();
  }
  // Raquette du jouur de droite
  if ((x == xdroite - 20) && (y > ydroite - 4) && (y < ydroite + 84) && (dx > 0)) {
    dx = -dx;
    raquette.rewind();
    raquette.play();
  }
}

// Ces quatre procédures permettent de tester plusieurs touches à la fois

void keyPressed(){
touches[keyCode]=true;
}
 
void keyReleased(){
touches[keyCode]=false;
}
 
boolean verifieClavier(char c){
int cc = int(c);
if(cc>96 && cc<123)cc-=32;
return touches[cc];
}
 
boolean verifieClavier(int c){
return touches[c];
}

// Fermeture de la librairie minim à la fin du programme
void stop() {
  rebond.close();
  minim.stop();
  super.stop();
}
