//Player player = new Player(width/2, height/2, 100, 10);
//ArrayList<Room> rooms;

interface Alive {
  Integer getHealth();
  Integer getStrength();
  Integer getSpeed();

  void setHealth(Integer newhealth);
  void setStrength(Integer newstrength);
  void setSpeed(Integer newspeed);
}

class Room {
  Integer number = 1;
  //ArrayList<Monster> enemies;
  //loot
}  

class Entity {
  Float x;
  Float y;
  PShape model;

  Entity(Float x, Float y) {
    this.x = x;
    this.y = y;
  }

  Float getX() {
    return x;
  }

  Float getY() {
    return y;
  }

  void setX(Float input) {
    x = input;
  }

  void setY(Float input) {
    y = input;
  }

  void display() {
    ellipse(x, y, 10, 10);
  }

  void detect(Entity other) {
    if (other.getX() == this.getX() && other.getY() == this.getY()) {
      //
    }
  }
}


class myBullet extends Entity {
  Integer strength;
  Float xDirection;
  Float yDirection;
  myBullet(Integer s, Float thisx, Float thisy, Float newx, Float newy) {
    super(thisx, thisy);
    strength = s;
    xDirection = newx;
    yDirection = newy;
  }
  void display() {
    model = createShape(ELLIPSE, x, y, 3, 3);
    model.setFill(color(0, 0, 0));
    shape(model);
  }
  void move() {
    if (x != xDirection && y != yDirection) {

      x -= (x - xDirection)/500.0;
      y -= (y - yDirection)/350.0;
    }
  }
  void die() {
    if (x <= 0 || x >= 1000 || y <= 0 || y >= 700) {
      bullets.remove(this);
    }
  }
}

class Player extends Entity implements Alive {
  Integer health;
  Integer strength;
  Integer speed;
  boolean up, down, left, right;
  PShape model;

  Player(Float newx, Float newy, Integer h, Integer str, Integer spd) {
    super(newx, newy);    
    health = h;
    strength = str;
    speed = spd;
  }
  void shoot() {
    if (mousex != null && mousey != null) {
      myBullet bullet = new myBullet(1, x, y, mousex, mousey);
      bullets.add(bullet);
    }
  }
  void display() {
    rectMode(CENTER);
    model = createShape(RECT, x, y, 10, 10);
    model.setFill(color(0, 255, 0));
    shape(model);
  }

  Integer getHealth() {
    return health;
  }
  Integer getStrength() {
    return strength;
  }
  Integer getSpeed() {
    return speed;
  }
  void setHealth(Integer newhealth) {
    health = newhealth;
  }

  void setStrength(Integer newstrength) {
    strength = newstrength;
  }

  void setSpeed(Integer newspeed) {
    speed = newspeed;
  }

  void move() {
    //Float diagonalFactor = Math.sqrt(1 / ((Math.pow(k,2)) + 1));
    //System.out.println(int(left) + " " + int(right));
    Float diagonalFactor = new Float(Math.sqrt(1 / ((Math.pow(1, 2)) + 1)));
    boolean diagonalMoving = up && left || up && right || down && left || down && right;
    if (diagonalMoving)
    {
      x += float(speed) * diagonalFactor * (float((int(right) - int(left))));
      y += float(speed) * diagonalFactor * (float((int(down) - int(up))));
    } else
    {
      x += float(speed) * float(int(right) - int(left));
      y += float(speed) * float(int(down) - int(up));
    }
  }
}



class Monster extends Entity implements Alive {
  Integer health, strength, speed;
  PShape model;
  Float xinc, yinc;

  Monster(Float newx, Float newy, Integer h, Integer str, Integer spd) {
    super(newx, newy);    
    health = h;
    strength = str;
    speed = spd;

    generateRandomXincYinc();
  }

  Integer getHealth() {
    return health;
  }
  Integer getStrength() {
    return strength;
  }
  Integer getSpeed() {
    return speed;
  }

  void setHealth(Integer newhealth) {
    health = newhealth;
  }
  void setStrength(Integer newstrength) {
    strength = newstrength;
  }
  void setSpeed(Integer newspeed) {
    speed = newspeed;
  }

  void display() {
    ellipseMode(CENTER);
    model = createShape(ELLIPSE, x, y, 10, 10);
    model.setFill(color(255, 0, 0));
    shape(model);
  }

  void move() {
    //jitter();
    straightLine();
  }

  private void bounceWallRealistic() {
    if (Math.abs(x + xinc - width/2) > (width/2 - 25))
      xinc *= -1;
    if (Math.abs(y + yinc - height/2) > (height/2 - 25))
      yinc *= -1;
  }
  private void bounceWallRandom() {
    if ((Math.abs(x + xinc - width/2) > (width/2 - 25)) || (Math.abs(y + yinc - height/2) > (height/2 - 25)))
    {
      do
      {
        xinc = random(-5, 5);
        yinc = random(-5, 5);
      } 
      while (5 - Math.abs(xinc) > 3 && 5 - Math.abs(yinc) > 3);
      //this loop ensures values from -5 to -2, and 2 to 5, but not small values 
      //for both x and y between -2 and 2.
    }
  }
  private void generateRandomXincYinc() {
    do
    {
      xinc = random(-5, 5);
      yinc = random(-5, 5);
    } 
    while (5 - Math.abs(xinc) > 3 && 5 - Math.abs(yinc) > 3);
  }

  private void jitter() {
    //float newWidth = x + xinc;
    //float newHeight = y + yinc;
    if (millis() % 1000 == 0)//if(frameCount % 60 == 0)
    {
      generateRandomXincYinc();
    }
    bounceWallRealistic();

    x += xinc;
    y += yinc;
  }

  private void straightLine() {
    bounceWallRealistic();

    x += xinc;
    y += yinc;
  }
}

void makeGrid() {
  rectMode(CORNER);
  for (int i = 0; i < width/10; i++) {
    for (int c = 0; c < height/10; c++) {
      if (i == 0 || i == width/10 - 1 || c * 10 == 0 || c== height/10 - 1) {
        fill(101, 67, 33);
        noStroke();
        rect(i * 10, c * 10, 10, 10);
      } else {
        noFill();
        stroke(0);
        rect(i * 10, c * 10, 10, 10);
      }
    }
  }
}

ArrayList<myBullet> bullets = new ArrayList<myBullet>(); 
Player player = new Player(500.0, 350.0, 5, 5, 5);
Monster monster = new Monster(500.0, 350.0, 5, 5, 5);

void keyPressed() {
  switch(key)
  {
  case 'w' : 
    player.up = true;
    break;
  case 's' : 
    player.down = true;
    break;
  case 'a' : 
    player.left = true;
    break;
  case 'd' : 
    player.right = true;
    break;
  }
}
void keyReleased() {
  switch(key)
  {
  case 'w' : 
    player.up = false;
    break;
  case 's' : 
    player.down = false;
    break;
  case 'a' : 
    player.left = false;
    break;
  case 'd' : 
    player.right = false;
    break;
  }
}

Float mousex;
Float mousey;

void mouseClicked() {
  mousex = (float) mouseX;
  mousey = (float) mouseY;
}
/*
void mousePressed() {
 mousex = (float) mouseX;
 mousey = (float) mouseY;
 }
 void mouseDragged() {
 mousex = (float) mouseX;
 mousey = (float) mouseY;
 }*/

void mouseReleased() {
  mousex = null;
  mousey = null;
}


void setup() {
  size(1000, 700);
  makeGrid();
  frameRate(70);
  //System.out.println(width/2);
  //System.out.println(player.getX());
  //player.display();
}

void draw() {
  System.out.println(frameRate);
  //System.out.println(mousex + " " + mousey);
  background(255);
  makeGrid();
  player.display();
  monster.display();
  player.move();
  monster.move();
  player.shoot();
  //monster.shoot();
  for (myBullet bullet : bullets) {
    bullet.display(); 
    bullet.move();
  }
  mousex = null;
  mousey = null;
}