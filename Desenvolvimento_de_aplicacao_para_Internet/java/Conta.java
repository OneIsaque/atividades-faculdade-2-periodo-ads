public class Conta {
    private StringBuilder sb = new StringBuilder();

    public void ContaInfo(){
        sb.append("--------------------").append("\n");
        sb.append("-----Info. Conta----").append("\n");
        sb.append("--------------------").append("\n");
    }


    public String getInfoConta(){
        return sb.toString();
    }
}
