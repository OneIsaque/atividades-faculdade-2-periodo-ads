public class Conta {
    private StringBuilder sb = new StringBuilder();

    public void ContaInfo(){
        sb.append("--------------------").append("\n");
        sb.append("-----Info. Conta----").append("\n");
        sb.append("--------------------").append("\n");
    }


    public String getContaInfo(){
        return sb.toString();
    }

    public static void texto1(){
        System.out.println("skfjlahlfhfkajfkahfkahkakdaksdkashdkashdkashdka");
    }
}
