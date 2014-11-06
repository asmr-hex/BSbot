/**
 * Created by connor on 10/23/14.
 */

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.Time;
import java.util.ArrayList;

public class arXivCrawler {

    /*Initialize Crawler's History */
    private static String[] Years;
    private static ArrayList<String> Months = new ArrayList<String>();
    private static ArrayList<String> Papers = new ArrayList<String>();
    /*Initialize number of retrieved abstracts */
    private static int nAbstracts = 0;
    /*Specify result directory */
    private static String resultDir = "../results/";
    /*Initialize Timer list*/
    private static double[] Times;

    public static void main(String[] args){
        /*Ensure number of arguments is correct*/
        if (args.length < 1){
            System.out.println("Usage: \n\tjava -jar arXivCrawler.jar n [resume] \n"
                                + "\t\tn:\t\t\tnumber of desired data samples\n"
                                + "\t\t[resume]:\tresume from stoppping point boolean");
            System.exit(-1);
        }
        /*To Do: set up Resume file */
        else if (args.length == 2){
            System.out.println("Resuming from _______ ...");
            System.exit(-1);
        }



        /*Get number of data points (number of real abstracts) */
        int n = Integer.parseInt(args[0]);
        System.out.println("Finding " + n + " ArXiv abstracts...");

        /*Set nanoTimes length */
        Times = new double[n];

        String baseURL = "http://arxiv.org";

        /*Level 1: Get URLs for all Years*/
        getYearURLs(baseURL);

        /*Retrieve n abstracts */
        for (int currentYear = 0; currentYear < Years.length; currentYear++){
            /* Level 2: Get URLs for Months in Current Year */
            getMonthURLs(baseURL + Years[currentYear]);
            for (int currentMonth = 0; currentMonth < Months.size(); currentMonth++){
                /* Level 3: Get URLs for Papers in Current Months */
                getPaperURLs(baseURL + Months.get(currentMonth));
                for (int currentPaper = 0; currentPaper < Papers.size(); currentPaper++) {
                    /* Level 4: Extract Titles and Abstracts from Current Paper */
                    /*Get start time (nanoseconds)*/
                    long start = System.nanoTime();
                    /*Retrieve Abstracts*/
                    String result = getAbstract(baseURL + Papers.get(currentPaper), nAbstracts);
                    /*Store results*/
                    try {
                        PrintWriter f = new PrintWriter(resultDir + Integer.toString(nAbstracts) + ".txt", "UTF-8");
                        f.write(result);
                        f.close();
                        nAbstracts += 1;
                    } catch (FileNotFoundException e) {
                        e.printStackTrace();
                    } catch (UnsupportedEncodingException e) {
                        e.printStackTrace();
                    }
                    /*Get end time (nanoseconds)*/
                    long end = System.nanoTime();
                    /*Store elapsed time in seconds */
                    Times[nAbstracts-1] = (end - start) * 1e-9;

                    if(nAbstracts == n) break;
                }
                if(nAbstracts == n) break;
            }
            if(nAbstracts == n) break;
        }

        /*Report Data Acquisition Statistics */
        /*Get mean*/
        double mean = 0;
        for (int k = 0; k < Times.length; k++) {
            mean += Times[k];
        }
        mean = mean/Times.length;
        /*Get stdev*/
        double stdev = 0;
        for (int k = 0; k < Times.length; k++) {
            stdev += Math.pow((Times[k] - mean), 2);
        }
        stdev = stdev / Times.length;
        stdev = Math.sqrt(stdev);
        System.out.println("\nData Acquisition Statistics:");
        System.out.println("\tmean  = " + Double.toString(mean));
        System.out.println("\tstdev = " + Double.toString(stdev));

    }

    /*Store Year links into global array */
    private static void getYearURLs(String baseURL){
        try {
            /*Get HTML document from HEP-TH Archive */
            String subDir = "/archive/hep-th";
            Document doc = Jsoup.connect(baseURL + subDir).get();
            /*Parse HTML doc and get list of links to each year */
            Element content = doc.getElementById("content");
            Elements linkList = content.getElementsContainingOwnText("Article statistics by year:");
            Elements links = linkList.get(0).getElementsByTag("a");
            /*Set Year array length */
            Years = new String[links.size()];
            /*Create Array of URLs to each year */
            for (int i = 0; i < links.size(); i++) {
                Years[i] = links.get(i).attr("href");
                //System.out.println(Years[i]);
            }
        } catch (IOException e) {
            //e.printStackTrace();
            System.out.println("\tBad Connection! Trying again...");
            getYearURLs(baseURL);
        }
    }

    /*Store Month links for current Year */
    private static void getMonthURLs(String yearURL){
        try {
            /*reset Months array */
            Months.clear();
            /*Get HTML document from HEP-TH current Year Archive */
            Document doc = Jsoup.connect(yearURL).get();
            /*Parse HTML doc and get list of links to each year */
            Element content = doc.getElementById("content");
            Elements linkList = content.getElementsByTag("ul");
            linkList = linkList.get(0).getElementsByTag("li");
            /*Traverse List of Months */
            for (int i = 0; i < linkList.size(); i++) {
                Element link = linkList.get(i).getElementsByTag("a").get(0);
                Months.add(i, link.attr("href"));
                //System.out.println(Months.get(i));
            }
        } catch (IOException e) {
            //e.printStackTrace();
            System.out.println("\tBad Connection! Trying again...");
            getMonthURLs(yearURL);
        }
    }


    /*Store Paper links for current Month */
    private static void getPaperURLs(String monthURL){
        try {
            /*set Months to null */
            Papers.clear();
            /*Get HTML document from HEP-TH current Month Archive */
            Document doc = Jsoup.connect(monthURL).get();
            /*Parse HTML doc and get list of links to each month */
            Element content = doc.getElementById("content");
            Elements linkList = content.getElementsByTag("dt");
            /*Traverse List of Papers */
            for (int i = 0; i < linkList.size(); i++) {
                Element link = linkList.get(i).getElementsByTag("a").get(1);
                Papers.add(i, link.attr("href"));
                //System.out.println(Papers.get(i));
            }
        } catch (IOException e) {
            //e.printStackTrace();
            System.out.println("\tBad Connection! Trying again...");
            getPaperURLs(monthURL);
        }
    }


    /*Retrieve Abstract*/
    private static String getAbstract(String paperURL, int n){
        String result = "";
        try {
            /*Get HTML document from HEP-TH current Paper */
            Document doc = Jsoup.connect(paperURL).get();
            /*Parse HTML doc and get list of links to each month */
            Element content = doc.getElementById("content");
            content = content.getElementsByClass("leftcolumn").get(0);
            /*Parse Title */
            Element titleTag = content.getElementsByClass("title").get(0);
            String Title = titleTag.childNode(1).toString();
            System.out.println("(" + n + ")\t" + Title);
            /*Parse Abstract */
            Element abstractTag = content.getElementsByClass("abstract").get(0);
            String Abstract = abstractTag.childNode(2).toString();
            //System.out.println(Abstract + "\n");

            /*Concatenate Title and Abstract */
            return Title.replaceAll(" ", "\n") + "\n\\\\" + Abstract.replaceAll(" ", "\n");

        } catch (IOException e) {
            //e.printStackTrace();
            System.out.println("\tBad Connection! Trying again...");
            result = getAbstract(paperURL, n);
        }
        return result;
    }


}
