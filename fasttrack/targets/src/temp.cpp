#include<vector>

std::vector<int> x;
extern "C" void solve(){
    x.push_back(5);
    x.push_back(10);
    x[0] = 6;
}

int main(){
    solve();
    return 0;

}
