import QtQuick 2.11
import QtQuick.Particles 2.0

//Item {
    ParticleSystem {
        property alias source: sprite.source
        property alias emitter: emitter
        property alias particle: particle

        //anchors.fill: parent

        ImageParticle {
            id: particle
            sprites: Sprite {
                id: sprite
                name: "snow"
                source: "images/snowflake.png"
                frameCount: 51; frameDuration: 40
                frameDurationVariation: 8
            }

            colorVariation: 0.8     //单个粒子颜色变化(0~1)
            entryEffect :ImageParticle.Fade     //出生和死亡时效果:渐显渐隐
        }

        Emitter {
            id: emitter
            width: parent.width; height: 0  //发射器大小(粒子出现范围)
            emitRate: 0.7;        //发射频率(缺省10) 和
            lifeSpan: 8000      //寿命(最大Emitter.InfiniteLife或大于60000,<=0则开始就死)
            velocity: PointDirection { y:100; yVariation: 40; } //起始速度,y为速度,yVariantion为偏移
            acceleration: PointDirection { y: 4 } //加速度,y为加速度
            size: 30; sizeVariation: 10     //开始时大小(默认16) 和 差异(默认0)
        }
    }
//}


