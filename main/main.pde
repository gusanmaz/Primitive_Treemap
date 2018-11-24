//Windows resizing works fine.
DataReader reader;
Tree tree;
LeafData[] leafData;
NonLeafData[] nonLeafData;
TreeNode[] leafDataFinal;
TreeNode[] nonLeafDataFinal;
color[] sqColors;
int rootID;
float w;
float h;
TreeNode selectedSquare;
boolean squareSelected;

void setup(){
  reader = new DataReader("../hierarchy5.csv");
  leafData    = reader.getLeafData();
  nonLeafData = reader.getNonLeafData();
  rootID      = reader.getRootID();
  squareSelected = false;
  selectedSquare = null;
  frame.setResizable(true);
  size(800,800);
}

void draw(){
  background(100,200,100);
  line(0, 0, width -1, 0);
  line(0, 0, 0, height -1);
  line(width -1, height -1, 0, height -1);
  line(width -1, height -1, width -1, 0);
  
  w = width;
  h = height;
  float bigger = (w>h) ? w:h;
  tree = new Tree(leafData, nonLeafData, rootID);
  tree.squarify(w,h);
  leafDataFinal = tree.getLeafNodes();
  nonLeafDataFinal = tree.getNonLeafNodes();
  rectMode(CORNERS);
  noFill();

  float x1, x2, y1, y2;
  textAlign(CENTER, CENTER);
  
  for(int i = 0; i < leafDataFinal.length; i++){
    leafDataFinal[i].setOffset(0.03);
    x1 = bigger * leafDataFinal[i].getX1();
    x2 = bigger * leafDataFinal[i].getX2();
    y1 = bigger * leafDataFinal[i].getY1();
    y2 = bigger * leafDataFinal[i].getY2();
    
    fill(255);
    rect(x1,y1,x2,y2);
    fill(0);
    text(str(leafDataFinal[i].getID()), x1, y1, x2, y2);
  }
  
  for(int i = 0; i < nonLeafDataFinal.length; i++){
    x1 = bigger * nonLeafDataFinal[i].getX1();
    x2 = bigger * nonLeafDataFinal[i].getX2();
    y1 = bigger * nonLeafDataFinal[i].getY1();
    y2 = bigger * nonLeafDataFinal[i].getY2();
    
    line(x1, y1, x1, y2);
    line(x1, y1, x2, y1);
    line(x2, y2, x2, y1);
    line(x2, y2, x1, y2);
  }

  if (squareSelected){
    textAlign(CENTER, CENTER);
    selectedSquare.setOffset(0.03);
    x1 = bigger * selectedSquare.getX1();
    x2 = bigger * selectedSquare.getX2();
    y1 = bigger * selectedSquare.getY1();
    y2 = bigger * selectedSquare.getY2();
    fill(200);
    rect(x1,y1,x2,y2);
    fill(0);
    text(str(selectedSquare.getID()), x1, y1, x2, y2);
  }
    
}

void mouseMoved(){
  float w = width;
  float h = height;
  float bigger = (w>h) ? w:h;
  float x = (mouseX / bigger);
  float y = (mouseY / bigger);
  TreeNode sq = tree.findSquare(x,y);
  if (sq != null){
    selectedSquare = sq;
    squareSelected = true;
  }
  else{
    squareSelected = false;
    selectedSquare = null;
  }
}
