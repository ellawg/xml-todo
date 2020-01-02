const capitalize = string => {
  string = string.charAt(0).toUpperCase() + string.substring(1);
  return string;
};

const getCategoryName = (categories, reqId) => {
  let categoryName;
  categories.forEach(item => {
    if (item.id === reqId) {
      categoryName = item.category;
    }
  });
  return categoryName;
};

module.exports = { capitalize, getCategoryName };
