int circleByFrame = 1;
PImage img;

float minSize = 1;

Circle c;

ArrayList<Circle> circles;
ArrayList<PVector> spots;
ArrayList<PVector> noSpots;

ArrayList<PVector> sortedSpots;
ArrayList<Float> spotMaxDim;


String fileName = "image";
String extIn = "jpg";
String extOut = "jpg";

float scaleRatio = 1.0;
float offsetX = 0;
float offsetY = 0;

boolean runningSave = false;

void setup(){
  size(500,500);
  
  img = loadImage(fileName+"."+extIn);
  img.loadPixels();
  
  spots = new ArrayList<PVector>();
  noSpots = new ArrayList<PVector>();
  
  sortedSpots = new ArrayList<PVector>();
  spotMaxDim = new ArrayList<Float>();
  
  circles = new ArrayList<Circle>();
  initSpots();
  sortSpots();
  
  //setScale();
  
}

void draw(){
  background(255);
  int count = 0;
  float lastSize = 0;

  while(count<circleByFrame){
    Circle c_ = newCircle();
    if(c_ != null){
      circles.add(c_);
      count ++;
      if(runningSave ==true){
        
        if(lastSize!=c_.r){
          lastSize=c_.r;
          for( Circle c : circles){
            c.show();
           }
          save(fileName+"-"+int(round(lastSize))+"."+extOut); 
          background(255);
        }
      }
    }else{
      noLoop();
      for( Circle c : circles){
        c.show();
      }
       save(fileName+"-final."+extOut); 
       println(" circlesSize = "+circles.size());
       println("no more space bro :-)");
       
       break;
    }
  }
  for( Circle c : circles){
    c.show();
  }
}

Circle newCircle(){
  
  boolean test = true;
  float spotX = 0;
  float spotY = 0;
  float spotR = 0;
  boolean complete = false;
  
   
   while(test == true){
     int index = sortedSpots.size()-1;
     if(index>=0){
       PVector spot  = sortedSpots.get(index);
     
      float x = spot.x;
      float y = spot.y;
      float maxDist = width*height;
      
      boolean valid = true;
      
      for(Circle c : circles){
       float d= dist(x,y,c.x,c.y);
       if(d<c.r){
         valid = false;
         break;
       }
      }
      if(valid){
       float[] val = {x,y,width-x,width-y};
       maxDist = min(val);
      }
      
      if(valid){
        for(PVector noSpot : noSpots){
          float d = dist(noSpot.x,noSpot.y,x,y);
          if(d<maxDist){
           maxDist = d; 
          }else if(d<minSize){
            valid = false;
            break;
          }
         }
       }
       if(valid){
         for(Circle c : circles){
           float d = dist(c.x,c.y,x,y);
           if(d-c.r <maxDist){
            maxDist = d-c.r; 
          }else if(d<minSize){
            valid = false;
            break;
          }
         }
       }
       
       maxDist = round(maxDist);
       
       if(valid && maxDist>minSize){
           spotX = spot.x;
           spotY = spot.y;
           spotR = maxDist;
           
         if(maxDist == spotMaxDim.get(index)){
           test = false;
           spotMaxDim.remove(index);
           sortedSpots.remove(index);
         }else{
          index-=1;
          for(int j = index ; j >=0 ; j--){
            if(j == 0){
              spotMaxDim.add(0,spotR);
              sortedSpots.add(0,spot);
              break;
            }else{
              float size  = spotMaxDim.get(j);
              if(spotR>=size){
                spotMaxDim.add(j,spotR);
                sortedSpots.add(j,spot);
                break;
              }
            } 
          }
        }   
       }
       if(index>=0){
         spotMaxDim.remove(spotMaxDim.size()-1);
        sortedSpots.remove(sortedSpots.size()-1);
        //println(spotMaxDim.size());
        if(spotMaxDim.size()==0){
          complete = true;
          return null;
        }
       }
       
     }
     
       
      }
      if(complete==false){
        return new Circle(spotX,spotY,spotR,scaleRatio,offsetX,offsetY);
      }else{
        return null;
   }
      
}

void initSpots(){
  for(int x = 0;x<img.width;x++){
    for(int y = 0;y<img.height;y++){
      
      int index = x+y*img.width;
      color c = img.pixels[index];
      float b = brightness(c);
      
      if(b<200){
        spots.add(new PVector(x,y));
        println(x,y);
      }else{
       noSpots.add(new PVector(x,y)); 
       println(x,y);
      }
    }
  }
}

void sortSpots(){
  for(int i = 0 ;i<spots.size(); i++){
    println("sorting : "+i+" / "+spots.size());
   PVector spot  = spots.get(i);
    
   float x = spot.x;
   float y = spot.y;
    
   float[] val = {x,y,img.width-x,img.height-y};
   float r = min(val);
  
   if(r>=minSize){
     for(PVector noSpot : noSpots){
     float d = dist(noSpot.x,noSpot.y,x,y);
     if(d<r){
        r = d; 
      }
      if(r<minSize){
       break;
     }
    }
    r=round(r);
    if(r>=minSize){
      int j = spotMaxDim.size();
      
      if(j == 0){
        spotMaxDim.add(0,r);
        sortedSpots.add(0,spot);
      }
      else{
        float size  = spotMaxDim.get(j-1);
        int med = int(spotMaxDim.size()/2);
        float medSize = spotMaxDim.get(med);
        
        while(r<medSize){
          j=med;
          med = int(med/2);
          medSize = spotMaxDim.get(med);
        }
        size  = spotMaxDim.get(j-1);
        while(r<size){
         j--;
         size  = spotMaxDim.get(j-1);
        }
        spotMaxDim.add(j,r);
        sortedSpots.add(j,spot);
      }
    }
   }
 }
}

void setScale(){
 float imgW = img.width;
 float imgH = img.height;
 float scaleH = 100;
 float scaleW = 100;
 
 if(imgW<width || imgH<height || imgW>width || imgH>height){
   if(imgW<width){
     scaleW = width/imgW;
   }
   if(imgH<height){
     scaleH = height/imgH;
   }
   if(imgW>width){
     scaleW = width/imgW;
   }
   if(imgH>height){
     scaleH = height/imgH;
   }
   if(scaleH<scaleW){
     scaleRatio = scaleH;
     offsetX = (width - imgW*scaleRatio)/2;
   }else{
     scaleRatio = scaleW;
     offsetY = (height - imgH*scaleRatio)/2;
   }
 }
  
}