let number = prompt("nhập vào số");
let array = number.split("");
let newArray = [];
console.log(array);
for (let i = 0; i < array.length; i++) {
    switch (array[i]) {
        case "1":
            newArray[i] = "một";
            break;
        case "2":
            newArray[i] = "hai";
            break;
        case "3":
            newArray[i] = "ba";
            break;
        case "4":
            newArray[i] = "bốn";
            break;
        case "5":
            newArray[i] = "năm";
            break;
        case "6":
            newArray[i] = "sáu";
            break;
        case "7":
            newArray[i] = "bảy";
            break;
        case "8":
            newArray[i] = "tám";
            break;
        case "9":
            newArray[i] = "chín";
            break;

    }
    document.getElementById("result").innerHTML += " " + newArray[i];
}
;

