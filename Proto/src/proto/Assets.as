package proto
{
    public class Assets
    {
        [Embed(source="../../../Assets/Testing/Testing.png")]
        public static const Testing:Class;
        [Embed(source="../../../Assets/Testing/Testing.xml", mimeType = "application/octet-stream")]
        public static const TestingXML:Class;

        [Embed(source="../../../Assets/Testing/Beep.mp3")]
        public static const Beep:Class;
    }
}
