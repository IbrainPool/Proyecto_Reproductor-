import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/src/helpers/helpers.dart';
import 'package:musicplayer/src/models/audio_player.dart';
import 'package:musicplayer/src/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';


class MusicPlayerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(),
          Column(
            children: <Widget>[
              CustmoAppBar(),
              ImagenDiscoDuracion(),
              TituloPlay(),
              Expanded(
                child: LyricsContainer(),
              )
            ],
          ),
        ],
      )
   );
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: screenSize.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
        gradient: LinearGradient(
          begin:  Alignment.centerLeft,
          end:  Alignment.center,
          colors: [
            Color(0xff33333E),
            Color(0xff201E28),
          ]
        )
      ),
    );
  }
}

class LyricsContainer extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();
    return Container(
      child: ListWheelScrollView(
        itemExtent: 42,
        diameterRatio: 1.5,
        physics: BouncingScrollPhysics(),
        children: lyrics.map((linea) => Text(linea, style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.8)),)).toList(),
      ),
    );
  }
}

class TituloPlay extends StatefulWidget {
  @override
  _TituloPlayState createState() => _TituloPlayState();
}

class _TituloPlayState extends State<TituloPlay> with SingleTickerProviderStateMixin{

  bool isPlaying = false;
  bool firstTime = true;
  AnimationController playAnimation;
  final assetAudioPlayer = new AssetsAudioPlayer();

  @override
  void initState() {
    playAnimation = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();

  }
  @override
  void dispose() {
    playAnimation.dispose();
    super.dispose();
  }
  void open(){
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);
    assetAudioPlayer.open('assets/sexi.mp3');
    assetAudioPlayer.currentPosition.listen((duration) {
      audioPlayerModel.current = duration;
    });
    assetAudioPlayer.current.listen((playingAudio) {
      audioPlayerModel.songDuration = playingAudio.duration;
    });   
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(top: 40),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('Do Ya Think Im Sexy', style: TextStyle(fontSize: 30, color: Colors.white.withOpacity(0.8)),),
              Text('The Warblres', style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.8)),)
            ],
          ),
          Spacer(),
          FloatingActionButton(
            backgroundColor: Color(0xFFF8CB51),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: playAnimation,
            ),
            elevation: 0,
            highlightElevation: 0,
            onPressed: () {
              final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);

              if(this.isPlaying){
                playAnimation.reverse();
                this.isPlaying = false;
                audioPlayerModel.controller.stop();
              }else{
                playAnimation.forward();
                this.isPlaying = true;
                audioPlayerModel.controller.repeat();
              }
              if(firstTime){
                this.open();
                firstTime = false;
              }else {
                assetAudioPlayer.playOrPause();
              }
            },
          )
        ],
      ),
    );
  }
}

class ImagenDiscoDuracion extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(top: 70),
      child: Row(
        children: <Widget>[
          ImagenDisco(),
          SizedBox(width: 30,),
          BarraProgreso(),
          SizedBox(width: 20,),
        ],
      ),
    );
  }
}

class BarraProgreso extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final estilo = TextStyle(color: Colors.white.withOpacity(0.4));
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final porcentaje = audioPlayerModel.getPorcentaje;
    
    return Container(
      child: Column(
        children: <Widget>[
          Text('${audioPlayerModel.songTotalDuration}', style: estilo,),
          Stack(
            children: <Widget>[
              Container(
                width: 3,
                height: 200,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 3,
                  height: 200 * porcentaje,
                  color: Colors.white.withOpacity(0.8),
                ),
              )
            ],
          ),
          Text('${audioPlayerModel.currentSecond}', style: estilo,),
        ],
      ),
    );
  }
}
class ImagenDisco extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    return Container(
      padding: EdgeInsets.all(20),
      height: 225,
      width: 225,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
             SpinPerfect(
               duration: Duration(seconds: 10),
               infinite: true,
               manualTrigger: true,
               controller: (animationController) => audioPlayerModel.controller = animationController,
               child: Image(image: AssetImage('assets/disco2.jpg'),)
              ),
             Container(
               width: 25,
               height: 25,
               decoration: BoxDecoration(
                 color: Colors.black38,
                 borderRadius: BorderRadius.circular(100)
               ),
             ),
             Container(
               width: 18,
               height: 18,
               decoration: BoxDecoration(
                 color: Color(0xFF1c1c25),
                 borderRadius: BorderRadius.circular(100)
               ),
             )
          ],
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xFF484750),
            Color(0xFF1E1C24),
          ]
        )
      ),
    );
  }
}