package proto
{
    import away3d.containers.View3D;
    import away3d.entities.Mesh;
    import away3d.primitives.PlaneGeometry;

    import feathers.controls.Button;

    import flash.geom.Vector3D;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.TextureAtlas;
    import starling.utils.AssetManager;

    import treefortress.sound.SoundAS;

    public class Prototype
    {
        private var _quad:Quad;

        public function Prototype(mainStarling:Starling, away3dView:View3D, assets:AssetManager)
        {
            away3dView.camera.z = -600;
            away3dView.camera.y = 500;
            away3dView.camera.lookAt(new Vector3D());

            var _plane = new Mesh(new PlaneGeometry(700, 700));
            away3dView.scene.addChild(_plane);

            var root:Sprite = Sprite(mainStarling.root);

            _quad = new Quad(100, 100);
            root.addChild(_quad);

            var testAtlas:TextureAtlas = assets.getTextureAtlas("Testing");

            var tile:Image = new Image(testAtlas.getTexture("A"));
            root.addChild(tile);

            SoundAS.addSound("beep", new Assets.Beep());

            var button:Button = new Button();
            button.label = "Test";
            button.x = 200;
            button.y = 200;
            button.addEventListener(Event.TRIGGERED, onTriggered);
            root.addChild(button);
        }

        private function onTriggered(event:Event):void
        {
            _quad.rotation += 0.1;
            _quad.x += 10;
            _quad.y += 10;

           SoundAS.play("beep");
        }
    }
}
