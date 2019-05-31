class Player extends Entity implements Alive {
  Integer maxHealth, armor, health, strength, speed;
  boolean up, down, left, right, dodge;
  PShape model;
  int energy = 100;

  Player(Float newx, Float newy, Integer h, Integer str, Integer spd) {
    super(newx, newy);
    maxHealth = h;
    health = h;
    strength = str;
    speed = spd;
    armor = 0;
  }

  void shoot() {
    if (mousex != null && mousey != null) {
      color bulletColor = color(0, 0, 0);
      myBullet bullet = new myBullet(1, this, mousex, mousey, 4.0, bulletColor);
      bullets.add(bullet);
      mousex = null;
      mousey = null;
    }
  }

  void display() {
    rectMode(CENTER);
    //model = createShape(ELLIPSE, getX(), getY(), 200, 200);
    model = createShape(ELLIPSE, getX(), getY(), 10, 10);
    model.setFill(color(0, 255, 0));
    shape(model);
    if (health <= 0) {
      this.die();
    }
  }

  Integer getMaxHealth() {
    return maxHealth;
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
  
  Integer getArmor() {
    return armor;
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
    //boolean diagonalMoving = up && left || up && right || down && left || down && right;

    velocity.set(float((int(right) - int(left))), float((int(down) - int(up))));
    velocity.setMag(float(getSpeed()));

    PVector holder = velocity;
    if (Math.abs(getX() + getXSpeed() - width/2) > (width/2 - 10))
      velocity.set(0, holder.y);
    if (Math.abs(getY() + getYSpeed() - height/2) > (height/2 - 10))
      velocity.set(holder.x, 0);

    if (dodge && energy > 25) {
      velocity.setMag(float(getSpeed()) * 4);
      location.add(velocity);
      velocity.set(holder);
      energy -= 25;
    } else {
      location.add(velocity);
      velocity.set(holder);
    }
    if (energy != 100) {
      energy++;
    }
  }

  void die() {
    endScreen();
  }
}