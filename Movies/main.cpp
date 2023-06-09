#include <QApplication>
#include "GUI.h"
#include "repository.h"
#include "service.h"
#include "movie.h"
#include <vector>
#include "validators.h"

int main(int argc, char *argv[]) {
    QApplication a(argc, argv);

    std::vector<Movie> repoAdminVector;
    repoAdminVector.reserve(10);
    std::string filename = R"(C\Users\Adi\Desktop\untitled2\movies)";
    Repository repo{repoAdminVector, filename};
    repo.initialiseRepo();
    Service service{repo};
    std::vector<Movie> repoUserVector;
    UserService userService{repo};
    MovieValidator validator{};

    GUI gui{service, userService, validator, repo};
    gui.show();
    return a.exec();
}