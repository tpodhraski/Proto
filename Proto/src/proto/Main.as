package proto
{
    import away3d.containers.View3D;
    import away3d.core.managers.Stage3DManager;
    import away3d.core.managers.Stage3DProxy;
    import away3d.debug.AwayStats;
    import away3d.events.Stage3DEvent;

    import feathers.themes.MinimalMobileTheme;

    import flash.display.MovieClip;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Rectangle;

    import proto.Assets;
    import proto.Prototype;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.utils.AssetManager;

    public class Main extends MovieClip
    {
        private var _stage3DProxy:Stage3DProxy;
        private var _mainStarling:Starling;
        private var _away3dView:View3D;
        private var _feathersTheme:MinimalMobileTheme;
        private var _assets:AssetManager;
        private var _prototype:Prototype;

        public function Main()
        {
            this.addEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function onAddedToStage(event:flash.events.Event):void
        {
            this.removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);

            this.stage.scaleMode = StageScaleMode.NO_SCALE;
            this.stage.align = StageAlign.TOP_LEFT;

            var stage3DManager:Stage3DManager = Stage3DManager.getInstance(stage);
            _stage3DProxy = stage3DManager.getFreeStage3DProxy();
            _stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
            _stage3DProxy.antiAlias = 0;
            _stage3DProxy.color = 0x000000;
        }

        private function onContextCreated(event:Stage3DEvent):void
        {
            _away3dView = new View3D();
            _away3dView.stage3DProxy = _stage3DProxy;
            _away3dView.shareContext = true;
            this.addChild(_away3dView);
            ///this.addChild(new AwayStats(_away3dView));

            _mainStarling = new Starling(Sprite, this.stage, _stage3DProxy.viewPort, _stage3DProxy.stage3D);
            _mainStarling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
            _mainStarling.start();
        }

        private function onRootCreated(event:starling.events.Event):void
        {
            _mainStarling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);

            _feathersTheme = new MinimalMobileTheme(false);

            _assets = new AssetManager();
            _assets.enqueue(Assets);
            _assets.loadQueue(function(ratio:Number):void
            {
                if (ratio == 1.0) startGame();
            });

            this.stage.addEventListener(flash.events.Event.RESIZE, onResize);
        }

        private function onResize(event:flash.events.Event):void
        {
            _stage3DProxy.width = event.target.stageWidth;
            _stage3DProxy.height = event.target.stageHeight;
            _mainStarling.viewPort = new Rectangle(0, 0, _stage3DProxy.width, _stage3DProxy.height);
            _mainStarling.stage.stageWidth = _stage3DProxy.width;
            _mainStarling.stage.stageHeight = _stage3DProxy.height;
            _away3dView.width = _stage3DProxy.width;
            _away3dView.height = _stage3DProxy.height;
        }

        private function startGame():void
        {
            _prototype = new Prototype(_mainStarling, _away3dView, _assets);

            _stage3DProxy.addEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);
        }

        private function onEnterFrame(event:flash.events.Event):void
        {
            _away3dView.render();
            _mainStarling.nextFrame();
        }
    }
}
