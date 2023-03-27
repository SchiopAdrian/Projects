#include <algorithm>
#include <fstream>
#include "CSVrepository.h"

CSVrepository::CSVrepository(const std::vector<Movie> &playlist, const std::string &userFilename) {
    this->playlist = playlist;
    this->userFilename = userFilename;
}

std::vector<Movie> &CSVrepository::getAllUsersRepo() {
    return this->playlist;
}

unsigned int CSVrepository::getSize() {
    return this->playlist.size();
}

unsigned int CSVrepository::getCapacity() {
    return this->playlist.capacity();
}

void CSVrepository::addUserRepo(const Movie &movie) {
    int existing = this->findByTitle(movie.getTitle());
    if(existing != -1)
    {
        std::string errors;
        errors += std::string("The movie is already in the playlist!");
        if(!errors.empty())
            throw UserException(errors);
    }
    this->playlist.push_back(movie);
    this->writeToFile();
}

void CSVrepository::removeUserRepo(unsigned int index) {
    this->playlist.erase(this->playlist.begin() + index);
    this->writeToFile();
}

int CSVrepository::findByTitle(const std::string &title) {
    int searchedIndex = -1;
    std::vector<Movie>::iterator it;
    it = std::find_if(this->playlist.begin(), this->playlist.end(), [&title](Movie& movie) {return movie.getTitle() == title;});
    if(it != this->playlist.end())
        searchedIndex = it - this->playlist.begin();
    return searchedIndex;
}

void CSVrepository::writeToFile() {
    std::ofstream fout(this->userFilename);
    if (!this->playlist.empty()) {
        for (const Movie& movie: this->playlist) {
            fout<<movie<<"\n";
        }
    }
    fout.close();
}

std::string &CSVrepository::getFilename() {
    return this->userFilename;
}

CSVrepository::~CSVrepository() = default;