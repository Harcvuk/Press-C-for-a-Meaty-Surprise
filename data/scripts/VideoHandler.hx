import hxvlc.openfl.Video;
import hxvlc.flixel.FlxVideo;
import hxvlc.flixel.FlxVideoSprite;

function onSubstateOpen(event) if (VideoHandler.curVideo != null && paused) VideoHandler.curVideo.pause();

function onSubstateClose(event) if (VideoHandler.curVideo != null && paused) VideoHandler.curVideo.resume();

function focusGained() if (VideoHandler.curVideo != null && !paused) VideoHandler.curVideo.resume();

public var camVideos:FlxCamera;

public var VideoHandler:T = {
        curVideo: null, //* FlxVideoSprite
        behindHUD: false,
        videosToPlay: [],
        load: function(paths:Array<String>, behindHUD:Bool, ?ext:String = "mp4", ?onEndReached:Void->Void)
        {
                VideoHandler.behindHUD = behindHUD;
                var _onEndReached:String->Void = onEndReached;

                camVideos = new FlxCamera();
                camVideos.bgColor = FlxColor.BLACK;
                FlxG.cameras.remove(camHUD, false);
                FlxG.cameras.add(camVideos, false);
                FlxG.cameras.add(camHUD, false);

                var prevAutoPause:Bool = FlxG.autoPause;
                FlxG.autoPause = false;

                for (path in paths)
                {
                        video = new FlxVideoSprite();
                        video.load(Assets.getPath(Paths.video(path, ext)));
                        video.cameras = [camVideos];
                        video.bitmap.onEndReached.add(function()
                        {
                                VideoHandler.curVideo.bitmap.dispose();
                                remove(VideoHandler.curVideo);

                                VideoHandler.videosToPlay.shift();
                                VideoHandler.curVideo = null;

                                if (_onEndReached != null)
                                        _onEndReached();
                        });
                        video.bitmap.onFormatSetup.add(function()
                        {
                                video.setGraphicSize(FlxG.width, FlxG.height);
                                video.screenCenter();
                        });
            video.alpha = 0;
            video.play();
            add(video);

                        VideoHandler.videosToPlay.push(video);

            video.pause();
            video.bitmap.time = 0;
                }

                FlxG.autoPause = prevAutoPause;
                if (FlxG.autoPause)
                {
                        for (video in VideoHandler.videosToPlay)
                                if (!FlxG.signals.focusLost.has(video.pause))
                                        FlxG.signals.focusLost.add(video.pause);

                        if (!FlxG.signals.focusGained.has(focusGained))
                                FlxG.signals.focusGained.add(focusGained);
                }
        },
        playNext: function()
        {
                VideoHandler.curVideo = VideoHandler.videosToPlay[0];
        VideoHandler.curVideo.alpha = 1;
                VideoHandler.curVideo.setGraphicSize(FlxG.width, FlxG.height);
                VideoHandler.curVideo.screenCenter();
                VideoHandler.curVideo.play();

        },
        forceEnd: function()
        {
                if (VideoHandler.curVideo == null)
                        return;

                VideoHandler.curVideo.bitmap.dispose();
                remove(VideoHandler.curVideo);

                VideoHandler.videosToPlay.shift();
                VideoHandler.curVideo = null;
        }
}

function destroy()
{
        for (i in VideoHandler.videosToPlay)
        {
                i.bitmap.dispose();
                remove(i);
        }
}