#include <curl/curl.h>
#include <sstream>

size_t WriteCallback(void* contents, size_t size, size_t nmemb, void* userp) {
    ((std::string*)userp)->append((char*)contents, size * nmemb);
    return size * nmemb;
}

std::string fetch(std::string url) {
    CURL* curl = curl_easy_init();;
    CURLcode res;
    std::string readBuffer;

    if (!curl) {
        return "Curl couldn't be initialized";
    }

    curl_easy_setopt(curl, CURLOPT_URL, url.c_str());

    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);

    res = curl_easy_perform(curl);

    curl_easy_cleanup(curl);

    if (res != CURLE_OK) {
        std::ostringstream err;
        err << "cURL error: " << curl_easy_strerror(res) << std::endl;
        return err.str();
    }

    return readBuffer;
}
