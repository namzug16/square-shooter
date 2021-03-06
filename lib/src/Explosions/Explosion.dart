
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:square_shooter/src/Particles/Particles.dart';

class Explosion {

  Explosion({
    required this.isSquare,
    required this.origin,
    this.velocityParticles = 10,
    this.sizeParticles = 10,
    this.amountParticles = 20,
    this.color = Colors.white,
});

  final bool isSquare;
  final Offset origin;
  final double sizeParticles;
  final double velocityParticles;
  final int amountParticles;
  final Color color;

  bool get isFinished => _isFinished();

  List<Particle> particles = [];
  void renderExplosion(Canvas c){
  if(particles.length < 1) _generateParticles();

  if(particles.length > 1 && !_isFinished()){
      for (var p in particles) {
        if (p.opacity == 0) particles.remove(p);
        p.renderParticle(c);
      }
    }
  }

  void _generateParticles(){
    final angle = 2*pi/amountParticles;
    for(var i = 0; i < amountParticles; i++){
      particles.add(
        Particle(
          initialVelocity: velocityParticles,
          size: sizeParticles,
          isSquare: isSquare,
          color: color,
          origin: origin,
          direction: angle*i,
        )
      );
    }
  }

  bool _isFinished(){
    if(particles.length > 1){
      if(particles[0].opacity <= 0){
        return true;
      }else{
        return false;
      }
    }
    return false;
    // return particles == null;
  }

}