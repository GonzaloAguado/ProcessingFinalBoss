import processing.sound.*;
import java.text.DecimalFormat;

//Sonidos 
SoundFile sonidoFinal, sonidocanon, sonidobowser;

//Creamos un objeto PImage, de nombre foto
PImage fondo,cannon,boss,muro,bola,caraBow,mira,gameov,win; 

//Vectores para la parabola de la bola
PVector location;
PVector velocity;
PVector gravity; 

//Velocidad y direcciones para bowser
float velocidad = 8.0;
float velocidad2 = 8.0;
int direccion = 1;
float xboss = 600;
float radio = 300.0;

//Segundos del juego
float s = 45;

//Colores de los rectangulos de vida
int colorin1 = 247;
int colorin2 = 247;
int colorin3 = 247;
int colorin4 = 247;
int colorin5 = 247;

//Vida de bowser
int vidabowser = 0;
boolean lanzado;

void setup(){
  size(1000,600); // tamaño de nuestro juego
  //cargamos un archivo de imÃ¡gen en foto
  fondo = loadImage("/img/fondo.jpg"); 
  cannon = loadImage("/img/cannonB.png");
  boss = loadImage("/img/bowserB.png");
  muro = loadImage("/img/wallBlue.png");
  bola = loadImage("/img/bolaFuegoB.png");
  caraBow = loadImage("/img/carabowserB.png");
  mira = loadImage("/img/mira.png");
  gameov = loadImage("/img/go.jpg");
  win = loadImage("/img/win.jpg");
  
  //POnemos la g y l
  location = new PVector(20,458);
  velocity = new PVector(10,14);
  gravity = new PVector(0,1);
  
  //Creacion de los sonidos 
  sonidoFinal = new SoundFile(this, "finalboss.mp3");
  sonidocanon = new SoundFile(this, "canon.mp3");
  sonidobowser = new SoundFile(this, "sonBowser.mp3");
  sonidoFinal.play();
}

void draw(){
  
  //Imagenes del juego
  image(fondo, 0,0, 1000,600); //Llamamos a la imagen del fondo
  image(bola, location.x,location.y,100,100); //Llamamos a la imagen de la bola fuego
  image(cannon, 0,420,160,175); //Llamamos a la imagen de cañon
  image(boss,xboss,300,420,425); //Llamamos a la imagen del jefe
  image(muro, 150,208,460,575); //Llamamos a la imagen de muro
  image(caraBow, 75,-100,260,300); //Llamamos a la imagen de muro
  
  //Color y rectangulo del suelo
  fill(11 ,3 , 32);
  rect(0,550,1000,50);
  
  //Rectangulos de la vida de bowser
  fill(colorin1 , 8 , 8);
  rect(250,40, 100, 40);
  fill(colorin2 , 8 , 8);
  rect(350,40, 100, 40);
  fill(colorin3 , 8 , 8);
  rect(450,40, 100, 40);
  fill(colorin4 , 8 , 8);
  rect(550,40, 100, 40);
  fill(colorin5 , 8 , 8);
  rect(650,40, 100, 40);
  strokeWeight(4);
  
  //Barras espaciadoras para la vida
  line(350 , 40 , 350 , 80);
  line(450 , 40 , 450 , 80);
  line(550 , 40 , 550 , 80);
  line(650 , 40 , 650 , 80);
  line(750 , 40 , 750 , 80);
  
  //Movimiento de Bowser
  xboss+= velocidad * direccion;
  
  //Si pulsa g que se lance
  if (keyPressed == true){
    //Si presiona la g
    if (key=='g') {
      sonidocanon.play();
      //Si la bola esta en el suelo re resetea
      if(location.y == 600){
        location.x = 20;
        location.y = 458;
        lanzado = false;
      }else{
        //Metodo de lanzar la bola
        lanzado = true;
      }
    }
  }
  
  //Llamo el metodo de lanzar
  if(lanzado == true){
    lanzar();
  }
  
  //Si la bola toca el suelo vuelve al cañon
  if(location.y == 600){
    location.x = 20;
        location.y = 458;
        lanzado = false;
  }
  
  //Si se sale del radio que hemos dicho va a otra direccion
  if((xboss > width - radio) || (xboss <radio)){
    direccion = -direccion;
  }
  
  //Colision de la bola con el bowser
  if(location.x >= xboss+100 && location.x <= xboss+250){
    if(location.y>= 400 && location.y<=600){
      //Aumentamos la vida de bowser
      vidabowser ++;
      sonidobowser.play();
      
      //Ajustamos la bola al cañon
      location.x = 20;
      location.y = 458;
      
      //Dependiendo de la vida del bowser se pinta cada rectangulo
      switch(vidabowser){
        //Si la vida es 1 pintamos rectangulo
        case 1:
          colorin5 = 50;
        break;
        //Si la vida es 2 pintamos rectangulo
        case 2:
          colorin4 =50;
        break;
        //Si la vida es 3 pintamos rectangulo
        case 3:
          colorin3 = 50;
        break;
        //Si la vida es 4 pintamos rectangulo
        case 4:
          colorin2 = 50;
        break;
        //Si la vida es 5 pintamos rectangulo
        case 5:
          colorin1 = 50;
        break;
      }
    }
  }
  
  //Creamos el formato que se vaya a ver del cronometro
  DecimalFormat formato1 = new DecimalFormat("#");
  formato1.format(s);
  
  //Si el cronometro es 0 mostramos la pantalla final
  if(s > 0){
    //Creamos el cronometro, tamaño, alineacion y formato
    fill(247 , 8 , 8); 
    textSize(45);
    textAlign(LEFT);
    text(formato1.format(s), 780, 76);
    
    //Restamos al cronometro
    s = s - 0.05;
  }else{
    //Paramos la musica
    sonidoFinal.stop();
    
    //sonidomuerte.play();
    image(gameov, 0,0, 1000,600);
  }
  
  //Si la vida de bowser es 5, HAS GANADO!
  if(vidabowser==5){
    sonidoFinal.stop();
    
    //Imagen de ganar
    image(win,0,0,1000,600);
  }
}

//Metodo para lanzar la bola
public void lanzar(){
  //Añado la velocidad a la bola
  location.add(velocity);
  //Añado la gravedad a la bola
  velocity.add(gravity);
      
  if ((location.x > width) || (location.x < 0)) {
    velocity.x = velocity.x * -1;
  }
    
  if (location.y > height) {        
    velocity.y = velocity.y * -0.95; 
    location.y = height;
  }
}
