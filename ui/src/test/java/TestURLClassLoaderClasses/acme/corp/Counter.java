package TestURLClassLoaderClasses.acme.corp;

public class Counter {
    public String name;
    private long value = 0;

    public Counter() {
    }

    public Counter(String aName) {
        name = aName;
    }

    static public String getVersion() {
        return "1.0";
    }

    public long getValue() {
        return value;
    }

    public void setValue(long val) {
        value = val;
    }

    public void inc() {
        value++;
    }
}